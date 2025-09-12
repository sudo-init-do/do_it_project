<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>instanta – Fleet Management</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
</head>
<body class="page">
<header class="topbar">
  <div class="brand">
    <div class="logo">instanta</div>
    <div class="app">Fleet Management</div>
  </div>
  <ul class="nav">
    <li><a href="#">Dashboard</a></li>
    <li><a href="#">Journey Mgmt</a></li>

    <li class="has-sub">
      <a href="#">Fleet Mgmt</a>
      <ul class="sub">
        <li class="has-sub">
          <a href="#">Maintenance ▸</a>
          <ul class="sub right">
            <li><a href="<%=request.getContextPath()%>/app/maintenance/new">New Maintenance</a></li>
            <li><a href="<%=request.getContextPath()%>/app/report?fmt=pdf">Export Report (PDF)</a></li>
            <li><a href="<%=request.getContextPath()%>/app/report?fmt=xlsx">Export Report (XLSX)</a></li>
            <li><a href="<%=request.getContextPath()%>/app/report?fmt=csv">Export Report (CSV)</a></li>
          </ul>
        </li>
      </ul>
    </li>

    <li><a href="#">Asset/Inventory Mgmt</a></li>
    <li><a href="#">Procurement Mgmt</a></li>
    <li><a href="#">Leases</a></li>
    <li><a href="#">References</a></li>
    <li><a href="#">User Admin</a></li>
    <li><a href="#">Reports</a></li>
    <li><a href="#">Help</a></li>
  </ul>
</header>

<main class="content">
  <div class="card">
    <div class="card-title">New Vehicle Maintenance Request</div>
    <p>Use the navigation: <b>Fleet Mgmt ▸ Maintenance ▸ New Maintenance</b></p>
  </div>
</main>
</body>
</html>
