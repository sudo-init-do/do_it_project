<%@ page contentType="text/html; charset=UTF-8" import="java.util.Map" %>
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

<main class="container" style="min-height:80vh;">
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
    <%
      Map reqObj = (Map) request.getAttribute("request");
      String rid = reqObj != null ? (String) reqObj.get("id") : "";
    %>
    <input type="hidden" name="id" value="<%= rid %>" />

      <div class="grid-2">
        <div class="field">
          <label>Office <span class="req">*</span></label>
          <select name="office" required>
            <option value="">--Select--</option>
            <option <%= (reqObj!=null && "Abuja".equals(reqObj.get("office")))?"selected":"" %>>Abuja</option>
            <option <%= (reqObj!=null && "Lagos".equals(reqObj.get("office")))?"selected":"" %>>Lagos</option>
            <option <%= (reqObj!=null && "Kano".equals(reqObj.get("office")))?"selected":"" %>>Kano</option>
          </select>
        </div>

        <div class="field">
          <label>Client</label>
          <select name="client">
            <option value="">--Select--</option>
            <option <%= (reqObj!=null && "Client A".equals(reqObj.get("client")))?"selected":"" %>>Client A</option>
            <option <%= (reqObj!=null && "Client B".equals(reqObj.get("client")))?"selected":"" %>>Client B</option>
          </select>
        </div>

        <div class="field">
          <label>Vehicle <span class="req">*</span></label>
          <select name="vehicle" required>
            <option value="">--Select--</option>
            <option <%= (reqObj!=null && "TRK-002".equals(reqObj.get("vehicle")))?"selected":"" %>>TRK-002</option>
            <option <%= (reqObj!=null && "BUS-014".equals(reqObj.get("vehicle")))?"selected":"" %>>BUS-014</option>
            <option <%= (reqObj!=null && "CAR-211".equals(reqObj.get("vehicle")))?"selected":"" %>>CAR-211</option>
          </select>
        </div>

        <div class="field">
          <label>Driver</label>
          <select name="driver">
            <option value="">--Select--</option>
            <option <%= (reqObj!=null && "John Doe".equals(reqObj.get("driver")))?"selected":"" %>>John Doe</option>
            <option <%= (reqObj!=null && "Mary Ann".equals(reqObj.get("driver")))?"selected":"" %>>Mary Ann</option>
            <option <%= (reqObj!=null && "Luke K".equals(reqObj.get("driver")))?"selected":"" %>>Luke K</option>
          </select>
        </div>

        <div class="field">
          <label>Fault Type <span class="req">*</span></label>
          <select name="faultType" required>
            <option value="">--Select--</option>
            <option <%= (reqObj!=null && "Tyres".equals(reqObj.get("faultType")))?"selected":"" %>>Tyres</option>
            <option <%= (reqObj!=null && "Engine".equals(reqObj.get("faultType")))?"selected":"" %>>Engine</option>
            <option <%= (reqObj!=null && "Brakes".equals(reqObj.get("faultType")))?"selected":"" %>>Brakes</option>
          </select>
        </div>

        <div class="field">
          <label>Status <span class="req">*</span></label>
          <select name="status" required>
            <option <%= (reqObj!=null && "Submitted".equals(reqObj.get("status")))?"selected":"" %>>Submitted</option>
            <option <%= (reqObj!=null && "In-Progress".equals(reqObj.get("status")))?"selected":"" %>>In-Progress</option>
            <option <%= (reqObj!=null && "Completed".equals(reqObj.get("status")))?"selected":"" %>>Completed</option>
          </select>
        </div>

        <div class="field">
          <label>Mileage</label>
          <input name="mileage" placeholder="e.g., 120345" value="<%= reqObj!=null ? reqObj.getOrDefault("mileage","") : "" %>">
        </div>

        <div class="field">
          <label>Date <span class="req">*</span></label>
          <input name="date" placeholder="dd/MM/yyyy" required value="<%= reqObj!=null ? reqObj.getOrDefault("date","") : "" %>">
          <small>Format: dd/MM/yyyy</small>
        </div>

        <div class="field">
          <label>Time <span class="req">*</span></label>
          <input name="time" placeholder="HH:mm" required value="<%= reqObj!=null ? reqObj.getOrDefault("time","") : "" %>">
          <small>24-hr time</small>
        </div>

        <div class="field">
          <label>Location</label>
          <input name="location" value="<%= reqObj!=null ? reqObj.getOrDefault("location","") : "" %>">
        </div>

        <div class="field">
          <label>Workshop</label>
      <input name="workshop" value="<%= reqObj!=null ? reqObj.getOrDefault("workshop","") : "" %>">
        </div>
      </div>

      <div class="field">
        <label>Complaint <span class="req">*</span></label>
        <textarea name="complaint" rows="3" placeholder="Describe the issue..." required><%= reqObj!=null ? reqObj.getOrDefault("complaint","") : "" %></textarea>
      </div>

      <div class="field">
        <label>Comments</label>
        <textarea name="comments" rows="3" placeholder="Any extra information..."><%= reqObj!=null ? reqObj.getOrDefault("comments","") : "" %></textarea>
      </div>

      <div class="field">
        <label>Attach files/images</label>
        <input type="file" name="attachment" multiple />
      </div>

      <% if (reqObj != null) { %>
        <div class="field">
          <label>Existing attachments</label>
          <ul>
            <% String att = (String) reqObj.getOrDefault("attachment", "");
               if (att != null && !att.trim().isEmpty()) {
                 String[] parts = att.split(",");
                 for (String a : parts) {
            %>
              <li><a href="<%=request.getContextPath()%>/app/maintenance/download?file=<%=a%>" download><%=a%></a></li>
            <%   }
               } else { %>
              <li style="color:var(--muted);">No attachments</li>
            <% } %>
          </ul>
        </div>
      <% } %>

      <div class="actions">
  <button type="button" class="btn primary" onclick="document.getElementById('maintForm').submit();"><%= (rid!=null && !rid.isEmpty())?"Save":"Create Maintenance" %></button>
  <button type="submit" class="btn success"><%= (rid!=null && !rid.isEmpty())?"Save":"Submit" %></button>
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
