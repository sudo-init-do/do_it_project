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
          <th>Attachment</th>
          <th>Submitted</th>
          <th>Export</th>
        </tr>
      </thead>
      <tbody>
        <% 
          java.util.List requests = (java.util.List)request.getAttribute("requests");
          if (requests != null && !requests.isEmpty()) {
            for (Object r : requests) {
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
        <tr>
          <td><%=office.trim()%></td>
          <td><%=client.trim()%></td>
          <td><%=vehicle.trim()%></td>
          <td><%=driver.trim()%></td>
          <td><%=status.trim()%></td>
          <td><%=date.trim()%></td>
          <td>
            <% if (!attachment.trim().isEmpty()) { %>
              <a href="/tmp/maint-uploads/<%=attachment.trim()%>" download class="download-btn">
                <span class="download-icon">&#128190;</span> Download
              </a>
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
          <td><small><%=dateSubmitted.trim()%></small></td>
        </tr>
        <%   }
          } else { %>
        <tr>
          <td colspan="8" style="text-align:center;">No history found.</td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
</main>
</body>
</html>
