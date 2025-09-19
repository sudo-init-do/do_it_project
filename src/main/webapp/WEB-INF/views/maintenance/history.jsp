<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Maintenance History</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
</head>
<body>
<header class="topbar slim">
  <div class="brand">
    <a class="brand-name" href="<%=request.getContextPath()%>/">instanta</a>
    <div style="white-space:pre-wrap; font-family:monospace; background:#fff; padding:16px; border-radius:8px; border:1px solid var(--line);">
      <%
        java.util.List hist = (java.util.List)request.getAttribute("history");
        if (hist == null || hist.isEmpty()) {
      %>
        <div>No history entries found.</div>
      <% } else {
           // render as blocks separated by the '----' separator used by the servlet
           StringBuilder block = new StringBuilder();
           for (Object o : hist) {
             String s = o == null ? "" : o.toString();
             if ("----".equals(s.trim())) {
               out.print(org.apache.commons.text.StringEscapeUtils.escapeHtml4(block.toString()));
               out.print("\n\n----\n\n");
               block.setLength(0);
             } else {
               block.append(s).append("\n");
             }
           }
           if (block.length() > 0) {
             out.print(org.apache.commons.text.StringEscapeUtils.escapeHtml4(block.toString()));
           }
         }
      %>
    </div>
            <% } else { %>
              -
            <% } %>
          </td>
          <td>
            <form method="get" action="<%=request.getContextPath()%>/app/report" style="display:inline;">
              <input type="hidden" name="office" value="<%=office.trim()%>" />
              <input type="hidden" name="client" value="<%=client.trim()%>" />
              <input type="hidden" name="vehicle" value="<%=vehicle.trim()%>" />
              <input type="hidden" name="driver" value="<%=driver.trim()%>" />
              <input type="hidden" name="status" value="<%=status.trim()%>" />
              <input type="hidden" name="date" value="<%=date.trim()%>" />
              <input type="hidden" name="dateSubmitted" value="<%=dateSubmitted.trim()%>" />
              <input type="hidden" name="complaint" value="" />
              <input type="hidden" name="comments" value="" />
              <input type="hidden" name="fmt" value="pdf" />
              <button type="submit" class="download-btn">PDF</button>
            </form>
            <form method="get" action="<%=request.getContextPath()%>/app/report" style="display:inline;">
              <input type="hidden" name="office" value="<%=office.trim()%>" />
              <input type="hidden" name="client" value="<%=client.trim()%>" />
              <input type="hidden" name="vehicle" value="<%=vehicle.trim()%>" />
              <input type="hidden" name="driver" value="<%=driver.trim()%>" />
              <input type="hidden" name="status" value="<%=status.trim()%>" />
              <input type="hidden" name="date" value="<%=date.trim()%>" />
              <input type="hidden" name="dateSubmitted" value="<%=dateSubmitted.trim()%>" />
              <input type="hidden" name="complaint" value="" />
              <input type="hidden" name="comments" value="" />
              <input type="hidden" name="fmt" value="xlsx" />
              <button type="submit" class="download-btn">Excel</button>
            </form>
            <form method="get" action="<%=request.getContextPath()%>/app/report" style="display:inline;">
              <input type="hidden" name="office" value="<%=office.trim()%>" />
              <input type="hidden" name="client" value="<%=client.trim()%>" />
              <input type="hidden" name="vehicle" value="<%=vehicle.trim()%>" />
              <input type="hidden" name="driver" value="<%=driver.trim()%>" />
              <input type="hidden" name="status" value="<%=status.trim()%>" />
              <input type="hidden" name="date" value="<%=date.trim()%>" />
              <input type="hidden" name="dateSubmitted" value="<%=dateSubmitted.trim()%>" />
              <input type="hidden" name="complaint" value="" />
              <input type="hidden" name="comments" value="" />
              <input type="hidden" name="fmt" value="csv" />
              <button type="submit" class="download-btn">CSV</button>
            </form>
          </td>
          <td><small><%=dateSubmitted.trim()%></small></td>
        </tr>
        <%   }
          } else { %>
        <tr>
          <td colspan="8" style="text-align:center;">No history found.</td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</main>
</body>
</html>
