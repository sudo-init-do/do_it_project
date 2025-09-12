package dev.oyeyemi.it.web;

import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import net.sf.jasperreports.export.*;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class ReportServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String fmt = Optional.ofNullable(req.getParameter("fmt")).orElse("pdf").toLowerCase(Locale.ROOT);

    // 1) Load JRXML
    InputStream jrxml = getServletContext().getResourceAsStream("/WEB-INF/reports/maintenance.jrxml");
    if (jrxml == null) throw new ServletException("JRXML not found: /WEB-INF/reports/maintenance.jrxml");

    // 2) Compile
    JasperReport report;
    try { report = JasperCompileManager.compileReport(jrxml); }
    catch (JRException e) { throw new ServletException("Compile failed", e); }

    // 3) Build single-row dataset from the submitted form
    Map<String,Object> row = new HashMap<>();
    put(req, row, "office");   put(req, row, "client");   put(req, row, "vehicle");
    put(req, row, "driver");   put(req, row, "faultType");put(req, row, "status");
    put(req, row, "mileage");  put(req, row, "date");     put(req, row, "time");
    put(req, row, "location"); put(req, row, "workshop"); put(req, row, "complaint");
    put(req, row, "comments");

  Collection<Map<String, ?>> rows = new ArrayList<>();
  rows.add(row);
  JRMapCollectionDataSource ds = new JRMapCollectionDataSource(rows);

    Map<String,Object> params = new HashMap<>();
    params.put("title", "Vehicle Maintenance Request");

    // 4) Fill
    JasperPrint jp;
    try { jp = JasperFillManager.fillReport(report, params, ds); }
    catch (JRException e) { throw new ServletException("Fill failed", e); }

    // 5) Export
    switch (fmt) {
      case "xlsx": {
        resp.setContentType(
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition","inline; filename=maintenance.xlsx");
        JRXlsxExporter exporter = new JRXlsxExporter();
        exporter.setExporterInput(new SimpleExporterInput(jp));
        exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(resp.getOutputStream()));
        SimpleXlsxReportConfiguration cfg = new SimpleXlsxReportConfiguration();
        cfg.setDetectCellType(true);
        exporter.setConfiguration(cfg);
        try { exporter.exportReport(); } catch (JRException e) { throw new ServletException(e); }
        break;
      }
      case "csv": {
        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition","inline; filename=maintenance.csv");
        JRCsvExporter exporter = new JRCsvExporter();
        exporter.setExporterInput(new SimpleExporterInput(jp));
        exporter.setExporterOutput(new SimpleWriterExporterOutput(resp.getWriter()));
        try { exporter.exportReport(); } catch (JRException e) { throw new ServletException(e); }
        break;
      }
      default: { // pdf
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition","inline; filename=maintenance.pdf");
        try { JasperExportManager.exportReportToPdfStream(jp, resp.getOutputStream()); }
        catch (JRException e) { throw new ServletException(e); }
      }
    }
  }

  private static void put(HttpServletRequest req, Map<String,Object> m, String name){
    m.put(name, Optional.ofNullable(req.getParameter(name)).orElse(""));
  }
}
