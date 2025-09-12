<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>instanta • Fleet Management</title>
  <link rel="stylesheet" href="css/app.css">
</head>
<body>
<header class="topbar">
  <div class="brand">
    <span class="logo-dot"></span>
    <span class="brand-name">instanta</span>
    <span class="app-name">Fleet Management</span>
  </div>

  <nav class="menu">
    <ul class="menu-root">
      <li><a href="#">Dashboard</a></li>
      <li><a href="#">Journey Mgmt</a></li>

      <li class="has-sub">
        <a href="#">Fleet Mgmt</a>
        <ul class="submenu">
          <li class="has-sub">
            <a href="#">Maintenance ▸</a>
            <ul class="submenu right">
              <li><a href="<%=request.getContextPath()%>/app/maintenance/new">New Maintenance</a></li>
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
  </nav>
</header>

<main class="container">
  <div class="card">
    <h3>New Vehicle Maintenance Request</h3>
    <p>Use the navigation: <b>Fleet Mgmt ▸ Maintenance ▸ New Maintenance</b></p>
  </div>
</main>
</body>
</html>
