package dev.oyeyemi.it.web;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class MaintenanceServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    String p = req.getPathInfo();
    if (p == null || "/".equals(p)) {
      // default: go to new form
      req.getRequestDispatcher("/WEB-INF/views/maintenance/new.jsp").forward(req, resp);
      return;
    }

    switch (p) {
      case "/new":
        req.getRequestDispatcher("/WEB-INF/views/maintenance/new.jsp").forward(req, resp);
        break;
      default:
        resp.sendError(404);
    }
  }
}
