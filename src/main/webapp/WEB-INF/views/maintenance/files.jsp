<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Attach Files</title>
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
  <a href="<%=request.getContextPath()%>/app/maintenance/files" class="tab active">Files</a>
  <a href="<%=request.getContextPath()%>/app/maintenance/past" class="tab">Past Maintenance(s)</a>
  <a href="<%=request.getContextPath()%>/app/maintenance/history" class="tab">History</a>
  <a href="<%=request.getContextPath()%>/app/maintenance/list" class="tab">List of Requests</a>
    </div>
    <h2>Attach Files to Maintenance Request</h2>
    <form method="post" action="<%=request.getContextPath()%>/app/maintenance/files" enctype="multipart/form-data">
      <div class="field">
        <label>Select File</label>
        <input type="file" name="attachment" required>
      </div>
      <div class="actions">
        <button type="submit" class="btn success">Upload File</button>
        <a class="btn ghost" href="<%=request.getContextPath()%>/app/maintenance/new">Back to Form</a>
      </div>
    </form>
    <hr>
    <h3>Uploaded Files</h3>
    <ul>
      <% 
        java.nio.file.Path uploadPath = java.nio.file.Paths.get("/tmp/maint-uploads");
        java.util.List<java.nio.file.Path> files = new java.util.ArrayList<>();
        try {
          if (java.nio.file.Files.exists(uploadPath)) {
            java.nio.file.DirectoryStream<java.nio.file.Path> stream = java.nio.file.Files.newDirectoryStream(uploadPath);
            for (java.nio.file.Path file : stream) {
              files.add(file);
            }
          }
        } catch (Exception e) {}
        if (files.isEmpty()) {
      %>
        <li style="color:var(--muted);">No files uploaded yet.</li>
      <% } else {
        for (java.nio.file.Path file : files) { %>
        <li><a href="/tmp/maint-uploads/<%=file.getFileName().toString()%>" download><%=file.getFileName().toString()%></a></li>
      <% } } %>
    </ul>
  </div>
</main>
</body>
</html>
