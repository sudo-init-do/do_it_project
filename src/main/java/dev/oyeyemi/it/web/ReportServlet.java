package dev.oyeyemi.it.web;

import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import net.sf.jasperreports.export.*;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;

public class ReportServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String fmt = Optional.ofNullable(req.getParameter("fmt"))
        .orElse("pdf")
        .toLowerCase(Locale.ROOT);

    // Load and compile JRXML
    InputStream jrxml = getServletContext().getResourceAsStream("/WEB-INF/reports/maintenance.jrxml");
    if (jrxml == null) {
      throw new ServletException("JRXML not found: /WEB-INF/reports/maintenance.jrxml");
    }

    JasperReport report;
    try {
      report = JasperCompileManager.compileReport(jrxml);
    } catch (JRException e) {
      throw new ServletException("Compile failed", e);
    }

    // Build dataset as List<Map<String, ?>> (not Map<String, Object>)
    List<Map<String, ?>> rows = new ArrayList<>();
    rows.add(row("Abuja","TRK-002","Tyres","Client A","John Doe","Submitted","2025-09-12","03:00","120345","HQ","—"));
    rows.add(row("Lagos","BUS-014","Engine","Client B","Mary Ann","In-Progress","2025-09-11","12:45","83321","Depot","Oil leak"));
    rows.add(row("Kano","CAR-271","Brakes","Client C","Luke K","Completed","2025-09-01","10:30","54900","Bay 2","Pads replaced"));

    JRMapCollectionDataSource ds = new JRMapCollectionDataSource(rows);

    Map<String,Object> params = new HashMap<>();
    params.put("title", "Vehicle Maintenance Requests");

    JasperPrint print;
    try {
      print = JasperFillManager.fillReport(report, params, ds);
    } catch (JRException e) {
      throw new ServletException("Fill failed", e);
    }

    try {
      switch (fmt) {
        case "xlsx": {
          resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
          resp.setHeader("Content-Disposition", "inline; filename=maintenance.xlsx");
          JRXlsxExporter exporter = new JRXlsxExporter();
          exporter.setExporterInput(new SimpleExporterInput(print));
          exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(resp.getOutputStream()));
          SimpleXlsxReportConfiguration cfg = new SimpleXlsxReportConfiguration();
          cfg.setDetectCellType(true);
          cfg.setCollapseRowSpan(false);
          exporter.setConfiguration(cfg);
          exporter.exportReport();
          break;
        }
        case "csv": {
          resp.setContentType("text/csv; charset=UTF-8");
          resp.setHeader("Content-Disposition", "inline; filename=maintenance.csv");
          JRCsvExporter exporter = new JRCsvExporter();
          exporter.setExporterInput(new SimpleExporterInput(print));
          exporter.setExporterOutput(new SimpleWriterExporterOutput(resp.getWriter()));
          exporter.exportReport();
          break;
        }
        default: {
          resp.setContentType("application/pdf");
          resp.setHeader("Content-Disposition", "inline; filename=maintenance.pdf");
          JasperExportManager.exportReportToPdfStream(print, resp.getOutputStream());
        }
      }
    } catch (JRException e) {
      throw new ServletException("Export failed", e);
    }
  }

  // Helper returns Map<String, Object> which is compatible with Map<String, ?>
  private static Map<String,Object> row(String office, String vehicle, String faultType,
                                        String client, String driver, String status,
                                        String date, String time, String mileage,
                                        String location, String comments) {
    Map<String,Object> m = new HashMap<>();
    m.put("office", office);
    m.put("vehicle", vehicle);
    m.put("faultType", faultType);
    m.put("client", client);
    m.put("driver", driver);
    m.put("status", status);
    m.put("date", date);
    m.put("time", time);
    m.put("mileage", mileage);
    m.put("location", location);
    m.put("comments", comments);
    return m;
  }
}
