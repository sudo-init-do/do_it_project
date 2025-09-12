<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Maintenance Submitted</title>
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
  <div class="card" style="text-align:center;">
    <h2>Maintenance Request Submitted!</h2>
    <p>Your maintenance request has been successfully created.</p>
    <div class="actions" style="justify-content:center;">
      <a href="<%=request.getContextPath()%>/app/maintenance/past" class="btn">View Past Maintenances</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/new" class="btn primary">Create Another</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/history" class="btn">View History</a>
    </div>
  </div>
</main>
</body>
</html>
