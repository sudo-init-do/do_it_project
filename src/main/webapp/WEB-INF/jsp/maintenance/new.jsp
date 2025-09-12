<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>New Vehicle Maintenance Request</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
</head>
<body class="page">
<header class="topbar">
  <div class="brand">
    <div class="logo">instanta</div>
    <div class="app">Fleet Management</div>
  </div>
  <ul class="nav">
    <li><a href="<%=request.getContextPath()%>/">Dashboard</a></li>
    <li class="has-sub">
      <a href="#">Fleet Mgmt</a>
      <ul class="sub">
        <li class="has-sub">
          <a href="#">Maintenance ▸</a>
          <ul class="sub right">
            <li><a class="active" href="<%=request.getContextPath()%>/app/maintenance/new">New Maintenance</a></li>
            <li><a href="<%=request.getContextPath()%>/app/report?fmt=pdf">Export Report (PDF)</a></li>
            <li><a href="<%=request.getContextPath()%>/app/report?fmt=xlsx">Export Report (XLSX)</a></li>
            <li><a href="<%=request.getContextPath()%>/app/report?fmt=csv">Export Report (CSV)</a></li>
          </ul>
        </li>
      </ul>
    </li>
  </ul>
</header>

<main class="content">
  <div class="card">
    <div class="tabs">
      <a class="tab active">Details</a>
      <a class="tab">Files</a>
      <a class="tab">Past Maintenance(s)</a>
      <a class="tab">History</a>
    </div>

    <h2 class="h2">New Vehicle Maintenance Request</h2>

    <form method="post" action="<%=request.getContextPath()%>/app/maintenance/new" class="grid">
      <div class="col">
        <label>Office <span class="req">*</span></label>
        <select required>
          <option>--Select--</option>
          <option>Abuja</option>
          <option>Lagos</option>
          <option>Kano</option>
        </select>

        <label>Vehicle <span class="req">*</span></label>
        <select required>
          <option>--Select--</option>
          <option>TRK-002</option>
          <option>BUS-014</option>
          <option>CAR-271</option>
        </select>

        <label>Fault Type <span class="req">*</span></label>
        <select required>
          <option>--Select--</option>
          <option>Tyres</option>
          <option>Engine</option>
          <option>Brakes</option>
        </select>

        <label>Mileage</label>
        <input type="text" placeholder="e.g., 120345"/>

        <label>Location</label>
        <input type="text" />
      </div>

      <div class="col">
        <label>Client</label>
        <select>
          <option>--Select--</option>
          <option>Client A</option>
          <option>Client B</option>
          <option>Client C</option>
        </select>

        <label>Driver</label>
        <select>
          <option>--Select--</option>
          <option>John Doe</option>
          <option>Mary Ann</option>
          <option>Luke K</option>
        </select>

        <label>Status <span class="req">*</span></label>
        <select required>
          <option>Submitted</option>
          <option>In-Progress</option>
          <option>Completed</option>
        </select>

        <label>Date <span class="req">*</span></label>
        <input type="text" placeholder="dd/MM/yyyy" required/>

        <label>Time <span class="req">*</span></label>
        <input type="text" placeholder="HH:mm" required/>
      </div>

      <div class="row">
        <label>Workshop</label>
        <input type="text"/>
      </div>

      <div class="row">
        <label>Complaint <span class="req">*</span></label>
        <textarea required placeholder="Describe the issue..."></textarea>
      </div>

      <div class="row">
        <label>Comments</label>
        <textarea placeholder="Any extra information..."></textarea>
      </div>

      <div class="actions">
        <button class="btn">Submit</button>
        <button type="reset" class="btn ghost">Clear</button>
        <div class="hint"><span class="req">*</span> Compulsory fields</div>
      </div>
    </form>
  </div>
</main>
</body>
</html>
