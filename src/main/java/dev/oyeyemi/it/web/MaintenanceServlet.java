package dev.oyeyemi.it.web;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

import java.util.*;
import java.nio.file.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@MultipartConfig(fileSizeThreshold=1024*1024*1, maxFileSize=1024*1024*10, maxRequestSize=1024*1024*15)

public class MaintenanceServlet extends HttpServlet {
  private static final String STORE = "/tmp/maint-requests.txt";

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
    if ("/past".equals(p)) {
      List<String> requests = Collections.emptyList();
      try {
        requests = Files.readAllLines(Paths.get(STORE));
      } catch (Exception ignored) {}
      req.setAttribute("requests", requests);
      req.getRequestDispatcher("/WEB-INF/views/maintenance/past.jsp").forward(req, resp);
      return;
    }
    if ("/history".equals(p)) {
      List<String> requests = Collections.emptyList();
      try {
        requests = Files.readAllLines(Paths.get(STORE));
      } catch (Exception ignored) {}
      req.setAttribute("requests", requests);
      req.getRequestDispatcher("/WEB-INF/views/maintenance/history.jsp").forward(req, resp);
      return;
    }
    if ("/list".equals(p)) {
      List<String> requests = Collections.emptyList();
      try {
        requests = Files.readAllLines(Paths.get(STORE));
      } catch (Exception ignored) {}
      req.setAttribute("requests", requests);
      req.getRequestDispatcher("/WEB-INF/views/maintenance/list.jsp").forward(req, resp);
      return;
    }
    resp.sendError(404);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String p = req.getPathInfo();
  if ("/files".equals(p) || "/files/".equals(p)) {
      Part filePart = req.getPart("attachment");
      String fileName = null;
      if (filePart != null && filePart.getSize() > 0) {
        fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        Path uploadPath = Paths.get("/tmp/maint-uploads");
        Files.createDirectories(uploadPath);
        Path filePath = uploadPath.resolve(fileName);
        filePart.write(filePath.toString());
      }
      resp.sendRedirect(req.getContextPath() + "/app/maintenance/files");
      return;
    }
    // Save maintenance request to file
    Map<String, String[]> params = req.getParameterMap();
    StringBuilder sb = new StringBuilder();
    for (String k : params.keySet()) {
      sb.append(k).append("=").append(Arrays.toString(params.get(k))).append("; ");
    }
    sb.append("dateSubmitted=").append(new Date()).append("; ");
    sb.append("\n");
    Files.write(Paths.get(STORE), sb.toString().getBytes(), StandardOpenOption.CREATE, StandardOpenOption.APPEND);
  req.getRequestDispatcher("/WEB-INF/views/maintenance/success.jsp").forward(req, resp);
  }
}
