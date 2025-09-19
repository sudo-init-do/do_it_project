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
    <span class="app-name">Fleet Management</span>
  </div>
</header>
<main class="container">
  <div class="card">
    <div class="tabs">
      <a href="<%=request.getContextPath()%>/app/maintenance/new" class="tab">Details</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/files" class="tab">Files</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/past" class="tab">Past Maintenance(s)</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/history" class="tab active">History</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/list" class="tab">List of Requests</a>
    </div>
    <h2>Maintenance History</h2>

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
  </div>
</main>
</body>
</html>
