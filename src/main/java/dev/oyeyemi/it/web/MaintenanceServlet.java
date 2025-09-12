package dev.oyeyemi.it.web;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MaintenanceServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String path = req.getPathInfo() == null ? "" : req.getPathInfo();
    if ("/new".equals(path)) {
      req.getRequestDispatcher("/WEB-INF/jsp/maintenance/new.jsp").forward(req, resp);
    } else {
      resp.sendRedirect(req.getContextPath() + "/app/maintenance/new");
    }
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    req.setAttribute("message", "Maintenance request submitted successfully.");
    req.getRequestDispatcher("/WEB-INF/jsp/success.jsp").forward(req, resp);
  }
}
