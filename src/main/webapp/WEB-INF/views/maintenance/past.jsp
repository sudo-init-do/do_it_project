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
      <a href="<%=request.getContextPath()%>/app/maintenance/files" class="tab">Files</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/past" class="tab active">Past Maintenance(s)</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/history" class="tab">History</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/list" class="tab">List of Requests</a>
    </div>
    <h2>Past Vehicle Maintenances</h2>
    
    <!-- Vehicle Filter -->
    <div style="margin-bottom: 16px; padding: 12px; background: #f8fafc; border-radius: 8px; border: 1px solid var(--line);">
      <form method="get" action="<%=request.getContextPath()%>/app/maintenance/past" style="display: flex; gap: 8px; align-items: center;">
        <label for="vehicle" style="font-weight: 500;">Filter by Vehicle:</label>
        <input type="text" id="vehicle" name="vehicle" value="<%=request.getAttribute("filterVehicle") != null ? request.getAttribute("filterVehicle") : ""%>" 
               placeholder="Enter vehicle number/name" style="padding: 6px 12px; border: 1px solid var(--line); border-radius: 4px; flex: 1; max-width: 300px;">
        <button type="submit" class="download-btn">Filter</button>
        <% if (request.getAttribute("filterVehicle") != null) { %>
          <a href="<%=request.getContextPath()%>/app/maintenance/past" class="download-btn" style="text-decoration: none;">Clear</a>
        <% } %>
      </form>
      <% if (request.getAttribute("filterVehicle") != null) { %>
        <p style="margin: 8px 0 0 0; color: var(--accent); font-size: 14px;">
          Showing maintenance history for vehicle: <strong><%=request.getAttribute("filterVehicle")%></strong>
        </p>
      <% } %>
    </div>
    <style>
      .table {
        width: 100%;
        border-collapse: collapse;
        font-size: 15px;
      }
      .table th, .table td {
        padding: 10px 12px;
        text-align: left;
      }
      .table th {
        background: var(--accent-quiet);
        color: var(--accent);
        font-weight: 600;
      }
      .table tr {
        border-bottom: 1px solid var(--line);
        transition: background 0.2s;
      }
      .table tr:hover {
        background: #f8fafc;
      }
      .download-btn {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 6px 10px;
        border: 1px solid var(--line);
        border-radius: 8px;
        background: var(--accent-quiet);
        color: var(--accent);
        text-decoration: none;
        font-size: 14px;
      }
      .download-btn:hover {
        background: var(--accent);
        color: #fff;
      }
      .download-icon {
        font-size: 16px;
      }
    </style>
    <table class="table">
      <thead>
        <tr>
          <th>Office</th>
          <th>Client</th>
          <th>Vehicle</th>
          <th>Driver</th>
          <th>Status</th>
          <th>Date</th>
          <th>Submitted</th>
          <th>Attachment</th>
        </tr>
      </thead>
      <tbody>
        <% 
          java.util.List requests = (java.util.List)request.getAttribute("requests");
          if (requests != null && !requests.isEmpty()) {
            for (int i = 0; i < requests.size(); i++) {
              Object r = requests.get(i);
              String line = r.toString();
              String[] vals = line.split("; ");
              String office = "", client = "", vehicle = "", driver = "", status = "", date = "", dateSubmitted = "", attachment = "";
              for (String v : vals) {
                if (v.startsWith("office=")) office = v.replace("office=","").replace("["," ").replace("]","");
                if (v.startsWith("client=")) client = v.replace("client=","").replace("["," ").replace("]","");
                if (v.startsWith("vehicle=")) vehicle = v.replace("vehicle=","").replace("["," ").replace("]","");
                if (v.startsWith("driver=")) driver = v.replace("driver=","").replace("["," ").replace("]","");
                if (v.startsWith("status=")) status = v.replace("status=","").replace("["," ").replace("]","");
                if (v.startsWith("date=")) date = v.replace("date=","").replace("["," ").replace("]","");
                if (v.startsWith("dateSubmitted=")) dateSubmitted = v.replace("dateSubmitted=","");
                if (v.startsWith("attachment=")) attachment = v.replace("attachment=","");
              }
        %>
        <tr style="border-bottom:1px solid var(--line);">
          <td><%=office.trim()%></td>
          <td><%=client.trim()%></td>
          <td><%=vehicle.trim()%></td>
          <td><%=driver.trim()%></td>
          <td><%=status.trim()%></td>
          <td><%=date.trim()%></td>
          <td><small><%=dateSubmitted.trim()%></small></td>
          <td>
            <% if (!attachment.trim().isEmpty() && i == requests.size()-1) { %>
              <a href="<%=request.getContextPath()%>/app/maintenance/download?file=<%=attachment.trim()%>" download class="download-btn">
                <span class="download-icon">&#128190;</span> Download
              </a>
            <% } else if (!attachment.trim().isEmpty()) { %>
              <span style="color:var(--muted);">Attached</span>
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
        </tr>
        <%   }
          } else { %>
        <tr>
          <td colspan="8" style="text-align:center;color:var(--muted);">No past maintenances found.</td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</main>
</body>
</html>
