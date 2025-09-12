<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>New Maintenance Request</title>
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
      <a href="<%=request.getContextPath()%>/app/maintenance/new" class="tab active">Details</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/files" class="tab">Files</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/past" class="tab">Past Maintenance(s)</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/history" class="tab">History</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/list" class="tab">List of Requests</a>
    </div>

    <h2>New Vehicle Maintenance Request</h2>

     
  <form id="maintForm" method="post" action="<%=request.getContextPath()%>/app/maintenance" enctype="multipart/form-data">

      <div class="grid-2">
        <div class="field">
          <label>Office <span class="req">*</span></label>
          <select name="office" required>
            <option value="">--Select--</option>
            <option>Abuja</option><option>Lagos</option><option>Kano</option>
          </select>
        </div>

        <div class="field">
          <label>Client</label>
          <select name="client">
            <option value="">--Select--</option>
            <option>Client A</option><option>Client B</option>
          </select>
        </div>

        <div class="field">
          <label>Vehicle <span class="req">*</span></label>
          <select name="vehicle" required>
            <option value="">--Select--</option>
            <option>TRK-002</option><option>BUS-014</option><option>CAR-211</option>
          </select>
        </div>

        <div class="field">
          <label>Driver</label>
          <select name="driver">
            <option value="">--Select--</option>
            <option>John Doe</option><option>Mary Ann</option><option>Luke K</option>
          </select>
        </div>

        <div class="field">
          <label>Fault Type <span class="req">*</span></label>
          <select name="faultType" required>
            <option value="">--Select--</option>
            <option>Tyres</option><option>Engine</option><option>Brakes</option>
          </select>
        </div>

        <div class="field">
          <label>Status <span class="req">*</span></label>
          <select name="status" required>
            <option>Submitted</option>
            <option>In-Progress</option>
            <option>Completed</option>
          </select>
        </div>

        <div class="field">
          <label>Mileage</label>
          <input name="mileage" placeholder="e.g., 120345">
        </div>

        <div class="field">
          <label>Date <span class="req">*</span></label>
          <input name="date" placeholder="dd/MM/yyyy" required>
          <small>Format: dd/MM/yyyy</small>
        </div>

        <div class="field">
          <label>Time <span class="req">*</span></label>
          <input name="time" placeholder="HH:mm" required>
          <small>24-hr time</small>
        </div>

        <div class="field">
          <label>Location</label>
          <input name="location">
        </div>

        <div class="field">
          <label>Workshop</label>
          <input name="workshop">
        </div>
      </div>

      <div class="field">
        <label>Complaint <span class="req">*</span></label>
        <textarea name="complaint" rows="3" placeholder="Describe the issue..." required></textarea>
      </div>

      <div class="field">
        <label>Comments</label>
        <textarea name="comments" rows="3" placeholder="Any extra information..."></textarea>
      </div>

      <div class="actions">
        <a href="<%=request.getContextPath()%>/app/maintenance/new" class="btn primary">Create Maintenance</a>
        <button type="submit" class="btn success">Submit</button>
        <!-- Export buttons can be handled separately if needed -->
        <a class="btn ghost" href="<%=request.getContextPath()%>/">Cancel</a>
      </div>
    </form>
  </div>
</main>

<script>
  function setFmt(f){ document.getElementById('fmt').value = f; }
</script>
</body>
</html>
