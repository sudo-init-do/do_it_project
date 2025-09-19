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

    <style>
      .history-grid { display:flex; flex-direction:column; gap:12px; }
      .history-card { background: #ffffff; border: 1px solid var(--line); padding:12px 16px; border-radius:10px; box-shadow:0 1px 2px rgba(0,0,0,0.03); }
      .history-header { font-weight:600; color:var(--accent); display:flex; gap:8px; align-items:center; font-family:monospace; }
      .history-meta { color:#666; font-size:13px; margin-left:auto; }
      .history-diffs { margin-top:8px; font-family:monospace; white-space:pre-wrap; color:#111; }
      .empty { color:#666; padding:10px; }
    </style>

    <div class="history-grid">
      <%
        java.util.List hist = (java.util.List)request.getAttribute("history");
        if (hist == null || hist.isEmpty()) {
      %>
        <div class="empty">No history entries found.</div>
      <% } else {
           // group lines into blocks separated by '----' (servlet writes that separator)
           java.util.List<java.util.List<String>> blocks = new java.util.ArrayList<>();
           java.util.List<String> current = new java.util.ArrayList<>();
           for (Object o : hist) {
             String s = o == null ? "" : o.toString();
             if ("----".equals(s.trim())) {
               if (!current.isEmpty()) { blocks.add(current); current = new java.util.ArrayList<>(); }
             } else {
               current.add(s);
             }
           }
           if (!current.isEmpty()) blocks.add(current);

           for (java.util.List<String> blk : blocks) {
             // first line expected to be like: "Fri Sep 19 19:04:40 WAT 2025 | update | id=..."
             String header = blk.size() > 0 ? blk.get(0) : "";
             StringBuilder diffs = new StringBuilder();
             for (int i=1;i<blk.size();i++) { diffs.append(blk.get(i)).append('\n'); }
      %>
      <div class="history-card">
        <div class="history-header">
          <div><%= org.apache.commons.text.StringEscapeUtils.escapeHtml4(header) %></div>
          <div class="history-meta"><%= blk.size()-1 %> change(s)</div>
        </div>
        <div class="history-diffs"><%= org.apache.commons.text.StringEscapeUtils.escapeHtml4(diffs.toString()) %></div>
      </div>
      <%     }
         }
      %>
    </div>
  </div>
</main>
</body>
</html>
