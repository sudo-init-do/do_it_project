<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Submitted</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/app.css">
</head>
<body class="page">
<main class="content">
  <div class="card">
    <h2 class="h2">Success</h2>
    <p><%= request.getAttribute("message") != null ? request.getAttribute("message") : "Done." %></p>
    <p><a class="btn" href="<%=request.getContextPath()%>/app/maintenance/new">Create another</a></p>
  </div>
</main>
</body>
</html>
