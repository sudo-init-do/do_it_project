<%@ page import="java.util.*,java.io.*" %>
<%
  List<String> requests = (List<String>) request.getAttribute("requests");
  if (requests == null) requests = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
  <title>List of Maintenance Requests</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css" />
</head>
<body>
<header class="topbar slim">
  <div class="brand">
    <a class="brand-name" href="<%=request.getContextPath()%>/">instanta</a>
    <span class="app-name">Fleet Management</span>
  </div>
</header>
<main class="container" style="display: flex; justify-content: center; align-items: flex-start; min-height: 80vh;">
  <div class="card" style="box-shadow: 0 4px 16px rgba(37,99,235,0.07); border-radius: 16px; padding: 32px 28px; max-width: 1200px; width: 100%;">
    <div class="tabs">
      <a href="<%=request.getContextPath()%>/app/maintenance/new" class="tab">Details</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/files" class="tab">Files</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/past" class="tab">Past Maintenance(s)</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/history" class="tab">History</a>
      <a href="<%=request.getContextPath()%>/app/maintenance/list" class="tab active">List of Requests</a>
    </div>
    <h2 style="margin-bottom: 18px;">All Maintenance Requests</h2>
    <style>
      .table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        font-size: 15px;
        background: #fff;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      }
      .table th, .table td {
        padding: 12px 14px;
        text-align: left;
        vertical-align: middle;
      }
      .table th {
        background: #e3edfa;
        color: #2563eb;
        font-weight: 700;
        border-bottom: 2px solid #dbeafe;
        letter-spacing: 0.02em;
        font-size: 16px;
      }
      .table tr {
        border-bottom: 1px solid var(--line);
        transition: background 0.2s;
      }
      .table tr:nth-child(even) {
        background: #f6f8fa;
      }
      .table tr:hover {
        background: #dbeafe;
      }
      .table td {
        font-size: 15px;
        color: #222;
        max-width: 180px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      @media (max-width: 900px) {
        .table th, .table td {
          padding: 8px 6px;
          font-size: 13px;
        }
      }
    </style>
    <div style="overflow-x: auto;">
      <table class="table" style="margin-bottom: 24px; min-width: 1000px;">
      <thead>
        <tr>
          <th>Office</th>
          <th>Client</th>
          <th>Vehicle</th>
          <th>Driver</th>
          <th>Status</th>
          <th>Date</th>
          <th>Fault Type</th>
          <th>Mileage</th>
          <th>Time</th>
          <th>Location</th>
          <th>Workshop</th>
          <th>Complaint</th>
          <th>Comments</th>
          <th>Attachment</th>
          <th>Submitted</th>
        </tr>
      </thead>
      <tbody>
        <% for (String line : requests) { 
             Map<String,String> map = new HashMap<>();
             String[] entries = line.split("; ");
             for(String entry : entries) {
               int idx = entry.indexOf('=');
               if(idx > 0) {
                 String key = entry.substring(0, idx).trim();
                 String val = entry.substring(idx+1).replaceAll("[\\[\\]]"," ").trim();
                 map.put(key, val);
               }
             }
        %>
          <tr>
            <td><%=map.getOrDefault("office","")%></td>
            <td><%=map.getOrDefault("client","")%></td>
            <td><%=map.getOrDefault("vehicle","")%></td>
            <td><%=map.getOrDefault("driver","")%></td>
            <td><%=map.getOrDefault("status","")%></td>
            <td><%=map.getOrDefault("date","")%></td>
            <td><%=map.getOrDefault("faultType","")%></td>
            <td><%=map.getOrDefault("mileage","")%></td>
            <td><%=map.getOrDefault("time","")%></td>
            <td><%=map.getOrDefault("location","")%></td>
            <td><%=map.getOrDefault("workshop","")%></td>
            <td><%=map.getOrDefault("complaint","")%></td>
            <td><%=map.getOrDefault("comments","")%></td>
            <td><%=map.getOrDefault("attachment","").isEmpty()?"-":map.get("attachment")%></td>
            <td><%=map.getOrDefault("dateSubmitted","")%></td>
          </tr>
        <% } %>
      </tbody>
    </table>
    <div style="margin-top: 24px;">
      <a href="<%=request.getContextPath()%>/app/maintenance/new" class="tab-btn">Create Maintenance</a>
    </div>
  </div>
</main>
</body>
</html>
