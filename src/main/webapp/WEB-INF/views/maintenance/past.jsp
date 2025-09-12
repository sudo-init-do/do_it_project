<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Past Maintenances</title>
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
      <button class="tab" disabled>Files</button>
      <button class="tab active">Past Maintenance(s)</button>
      <button class="tab" disabled>History</button>
    </div>
    <h2>Past Vehicle Maintenances</h2>
    <table class="table">
      <thead>
        <tr>
          <th>Office</th>
          <th>Client</th>
          <th>Vehicle</th>
          <th>Driver</th>
          <th>Status</th>
          <th>Date</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <!-- TODO: Dynamically list past maintenances here -->
        <tr>
          <td colspan="7" style="text-align:center;">No past maintenances found.</td>
        </tr>
      </tbody>
    </table>
  </div>
</main>
</body>
</html>
