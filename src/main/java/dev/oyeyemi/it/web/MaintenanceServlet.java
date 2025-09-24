package dev.oyeyemi.it.web;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

import java.util.*;
import java.nio.file.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

@MultipartConfig(fileSizeThreshold=1024*1024*1, maxFileSize=1024*1024*20, maxRequestSize=1024*1024*50)
public class MaintenanceServlet extends HttpServlet {
  // store one record per line (legacy format key=value; key2=value2; ...)
  private static final String STORE = "/tmp/maint-requests.jsonl"; // primary (new)
  private static final String LEGACY_STORE = "/tmp/maint-requests.txt"; // old location used earlier in the project
  private static final String HISTORY_STORE = "/tmp/maint-history.txt";
  private static final Path UPLOAD_DIR = Paths.get("/tmp/maint-uploads");

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String p = req.getPathInfo();
    if (p == null || "/".equals(p) || "/new".equals(p)) {
      req.getRequestDispatcher("/WEB-INF/views/maintenance/new.jsp").forward(req, resp);
      return;
    }
    if ("/files".equals(p) || "/files/".equals(p)) {
      req.getRequestDispatcher("/WEB-INF/views/maintenance/files.jsp").forward(req, resp);
      return;
    }
    if ("/history".equals(p)) {
      // serve human readable history entries (one-line or multi-line blocks) to the history view
      List<String> hist = new ArrayList<>();
      try {
        Path ph = Paths.get(HISTORY_STORE);
        if (Files.exists(ph)) hist = Files.readAllLines(ph, StandardCharsets.UTF_8);
      } catch (Exception ignored) {}
      req.setAttribute("history", hist);
      req.getRequestDispatcher("/WEB-INF/views/maintenance/history.jsp").forward(req, resp);
      return;
    }

    if ("/past".equals(p) || "/list".equals(p)) {
      // read raw lines, parse to maps, ensure every record has an id (migrate legacy records), persist if changed
      List<String> existing = readLines();
      List<Map<String,String>> parsed = parseLines(existing);
      boolean changed = ensureIds(parsed);
      if (changed) {
        writeRecords(parsed);
        // regenerate lines for JSP
        existing = serializeRecords(parsed);
      }
      
      // for past maintenance, filter by vehicle if specified
      if ("/past".equals(p)) {
        String filterVehicle = req.getParameter("vehicle");
        if (filterVehicle != null && !filterVehicle.trim().isEmpty()) {
          List<String> filtered = new ArrayList<>();
          for (String line : existing) {
            if (line.contains("vehicle=" + filterVehicle.trim())) {
              filtered.add(line);
            }
          }
          existing = filtered;
          req.setAttribute("filterVehicle", filterVehicle.trim());
        }
      }
      
      req.setAttribute("requests", existing);
      String view = "/WEB-INF/views/maintenance/" + ("/past".equals(p) ? "past.jsp" : "list.jsp");
      req.getRequestDispatcher(view).forward(req, resp);
      return;
    }
    if ("/download".equals(p)) {
      String name = req.getParameter("file");
      if (name == null) { resp.sendError(404); return; }
      Path f = UPLOAD_DIR.resolve(name).normalize();
      if (!f.startsWith(UPLOAD_DIR) || !Files.exists(f)) { resp.sendError(404); return; }
      String type = Files.probeContentType(f);
      if (type == null) type = "application/octet-stream";
      resp.setContentType(type);
      resp.setHeader("Content-Disposition","attachment; filename=" + URLEncoder.encode(f.getFileName().toString(), StandardCharsets.UTF_8.toString()));
      Files.copy(f, resp.getOutputStream());
      return;
    }
    if ("/edit".equals(p)) {
      String id = req.getParameter("id");
      String lineParam = req.getParameter("line");
      if ((id == null || id.trim().isEmpty()) && (lineParam == null || lineParam.trim().isEmpty())) {
        resp.sendError(404);
        return;
      }
      Map<String,String> m = null;
      if (id != null && !id.trim().isEmpty()) {
        // find by id
        List<String> requests = readLines();
        for (String line : requests) {
          if (line.contains("id=" + id)) {
            m = parseLine(line);
            break;
          }
        }
        if (m == null) { resp.sendError(404); return; }
      } else {
        // decode provided raw line
        try {
          String decoded = java.net.URLDecoder.decode(lineParam, java.nio.charset.StandardCharsets.UTF_8.toString());
          m = parseLine(decoded);
        } catch (Exception e) {
          resp.sendError(400);
          return;
        }
      }
      req.setAttribute("request", m);
      req.getRequestDispatcher("/WEB-INF/views/maintenance/new.jsp").forward(req, resp);
      return;
    }
    resp.sendError(404);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String p = req.getPathInfo();
    if ("/upload".equals(p) || "/files".equals(p)) {
      Files.createDirectories(UPLOAD_DIR);
      Part filePart = req.getPart("attachment");
      if (filePart != null && filePart.getSize() > 0) {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        Path filePath = UPLOAD_DIR.resolve(fileName);
        Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
      }
      resp.sendRedirect(req.getContextPath() + "/app/maintenance/files");
      return;
    }

  // handle create/save of a maintenance record (multipart)
    Files.createDirectories(UPLOAD_DIR);
    req.setCharacterEncoding("UTF-8");
    String id = Optional.ofNullable(req.getParameter("id")).orElse("");
    boolean isEdit = id != null && !id.isEmpty();
    if (!isEdit) id = UUID.randomUUID().toString();

    // collect parameters
    Map<String,String> record = new LinkedHashMap<>();
    record.put("id", id);
    record.put("dateSubmitted", new Date().toString());
    // expected fields (gracefully handle missing)
    String[] fields = new String[]{"office","client","vehicle","driver","faultType","status","mileage","date","time","location","workshop","complaint","comments"};
    for (String f : fields) {
      String v = Optional.ofNullable(req.getParameter(f)).orElse("");
      record.put(f, v);
    }

    // handle uploaded files (multiple)
    List<String> added = new ArrayList<>();
    for (Part part : req.getParts()) {
      if (part.getSubmittedFileName() != null && part.getSize() > 0) {
        String original = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String stored = id + "-" + System.currentTimeMillis() + "-" + original;
        Path dest = UPLOAD_DIR.resolve(stored);
        Files.copy(part.getInputStream(), dest, StandardCopyOption.REPLACE_EXISTING);
        added.add(stored);
      }
    }

    // read existing records and update or append
    List<String> existingLines = readLines();
    List<Map<String,String>> records = new ArrayList<>();
    // convert raw lines into maps
    for (String line : existingLines) {
      Map<String,String> r = new LinkedHashMap<>();
      String[] parts = line.split("; ");
      for (String pentry : parts) {
        int idx = pentry.indexOf('=');
        if (idx > 0) {
          String k = pentry.substring(0, idx).trim();
          String v = pentry.substring(idx+1).trim();
          r.put(k, v);
        }
      }
      records.add(r);
    }
    if (isEdit) {
      boolean found = false;
      for (Map<String,String> r : records) {
        if (id.equals(r.get("id"))) {
          // compute comprehensive diffs before applying - capture all field changes
          Map<String,String> oldCopy = new LinkedHashMap<>(r);
          Map<String,String> diffs = new LinkedHashMap<>();
          
          // check all fields that might have changed (both old and new)
          Set<String> allKeys = new HashSet<>(oldCopy.keySet());
          allKeys.addAll(record.keySet());
          
          for (String k : allKeys) {
            String oldV = oldCopy.getOrDefault(k, "");
            String newV = record.getOrDefault(k, "");
            // track all changes, including empty -> value and value -> empty
            if (!Objects.equals(oldV, newV)) {
              String oldDisplay = oldV.isEmpty() ? "(empty)" : oldV;
              String newDisplay = newV.isEmpty() ? "(empty)" : newV;
              diffs.put(k, oldDisplay + " -> " + newDisplay);
            }
          }
          // merge attachments
          String oldAttach = r.getOrDefault("attachment", "");
          String merged = oldAttach;
          if (!added.isEmpty()) {
            if (!merged.isEmpty()) merged += ",";
            merged += String.join(",", added);
          }
          if (!Objects.equals(oldAttach, merged)) {
            diffs.put("attachment", oldAttach + " -> " + merged);
          }
          // apply updates
          r.putAll(record);
          r.put("attachment", merged);
          // record history
          appendHistoryEntry(id, diffs, "update");
          found = true;
          break;
        }
      }
      if (!found) {
        // fallback to append
        if (!added.isEmpty()) record.put("attachment", String.join(",", added));
        records.add(record);
        appendHistoryEntry(id, record, "create");
      }
    } else {
      if (!added.isEmpty()) record.put("attachment", String.join(",", added));
      records.add(record);
      appendHistoryEntry(id, record, "create");
    }
    writeRecords(records);

    // after save redirect to list so user can immediately see and edit
    resp.sendRedirect(req.getContextPath() + "/app/maintenance/list");
  }

  // return raw lines (format: key=value; key2=value2; ...)
  private List<String> readLines() {
    List<String> out = new ArrayList<>();
    try {
      Path pNew = Paths.get(STORE);
      Path pOld = Paths.get(LEGACY_STORE);
      if (Files.exists(pNew)) out.addAll(Files.readAllLines(pNew));
      if (Files.exists(pOld)) out.addAll(Files.readAllLines(pOld));
    } catch (Exception e) {
      // ignore and return what we have
    }
    return out;
  }

  private List<Map<String,String>> parseLines(List<String> lines) {
    List<Map<String,String>> out = new ArrayList<>();
    for (String line : lines) {
      if (line == null || line.trim().isEmpty()) continue;
      Map<String,String> m = new LinkedHashMap<>();
      String[] parts = line.split("; ");
      for (String p : parts) {
        int idx = p.indexOf('=');
        if (idx > 0) {
          String k = p.substring(0, idx).trim();
          String v = p.substring(idx+1).trim();
          m.put(k, v);
        }
      }
      out.add(m);
    }
    return out;
  }

  private Map<String,String> parseLine(String line) {
    Map<String,String> m = new LinkedHashMap<>();
    if (line == null || line.trim().isEmpty()) return m;
    String[] parts = line.split("; ");
    for (String p : parts) {
      int idx = p.indexOf('=');
      if (idx > 0) {
        String k = p.substring(0, idx).trim();
        String v = p.substring(idx+1).trim();
        m.put(k, v);
      }
    }
    return m;
  }

  private boolean ensureIds(List<Map<String,String>> records) {
    boolean changed = false;
    for (Map<String,String> r : records) {
      if (!r.containsKey("id") || r.get("id").trim().isEmpty()) {
        r.put("id", UUID.randomUUID().toString());
        changed = true;
      }
    }
    return changed;
  }

  private List<String> serializeRecords(List<Map<String,String>> records) {
    List<String> out = new ArrayList<>();
    for (Map<String,String> r : records) {
      StringBuilder sb = new StringBuilder();
      for (Map.Entry<String,String> e : r.entrySet()) {
        sb.append(e.getKey()).append("=").append(e.getValue() == null ? "" : e.getValue()).append("; ");
      }
      out.add(sb.toString());
    }
    return out;
  }

  private void appendHistoryEntry(String id, Map<String,String> changes, String type) {
    try {
      StringBuilder sb = new StringBuilder();
      sb.append(new Date()).append(" | ").append(type).append(" | id=").append(id).append("\n");
      for (Map.Entry<String,String> e : changes.entrySet()) {
        sb.append("  ").append(e.getKey()).append(": ").append(e.getValue()).append("\n");
      }
      sb.append("----\n");
      Files.write(Paths.get(HISTORY_STORE), sb.toString().getBytes(StandardCharsets.UTF_8), StandardOpenOption.CREATE, StandardOpenOption.APPEND);
    } catch (Exception ignored) {}
  }

  // write records in the older semicolon-separated format so existing JSPs continue to work
  private void writeRecords(List<Map<String,String>> records) throws IOException {
    StringBuilder sb = new StringBuilder();
    for (Map<String,String> r : records) {
      for (Map.Entry<String,String> e : r.entrySet()) {
        sb.append(e.getKey()).append("=").append(e.getValue() == null ? "" : e.getValue()).append("; ");
      }
      sb.append('\n');
    }
    byte[] data = sb.toString().getBytes(StandardCharsets.UTF_8);
    // write to primary store
    Files.write(Paths.get(STORE), data, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    // also write to legacy store for backward compatibility
    try {
      Files.write(Paths.get(LEGACY_STORE), data, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
    } catch (Exception ignored) {}
  }
}
