<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
  <title>Tor Metrics</title>
  <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  <link href="css/stylesheet-ltr.css" type="text/css" rel="stylesheet">
  <link href="images/favicon.ico" type="image/x-icon" rel="shortcut icon">
</head>
<body>
  <div class="center">
    <div class="main-column">
        <h2><a href="/"><img src="images/metrics-logo.png" width="153" height="200" alt="Metrics logo"><img src="images/metrics-wordmark.png" width="384" height="50" alt="Metrics wordmark"></a></h2>
        <br>
        <p>Welcome to Tor Metrics, the primary place to learn interesting
        facts about the Tor network, the largest deployed anonymity
        network to date.
        If something can be measured safely, you'll find it here.*</p>
        <p><small>*And if you come across something that is missing here,
        please
        <a href="https://www.torproject.org/about/contact.html.en">let us
        know</a>.</small></p>

<div>
<div style="border:1px solid gray;border-radius:10px;padding:10px;float:left;overflow:hidden;margin-right:20px;">
<form action="/">
<p>
<b>Tags</b><br>
<c:forEach var="row" items="${tags}">
<label><input name="tag" type="checkbox" value="${row[0]}" <c:if test="${fn:length(row[2]) > 0}"> checked</c:if>> ${row[1]}</label></br>
</c:forEach>
</p>
<p>
<b>Type</b></br>
<c:forEach var="row" items="${types}">
<label><input name="type" type="checkbox" value="${row[0]}" <c:if test="${fn:length(row[2]) > 0}"> checked</c:if>> ${row[1]}</label></br>
</c:forEach>
</p>
<p>
<b>Level</b></br>
<c:forEach var="row" items="${levels}">
<label><input name="level" type="checkbox" value="${row[0]}" <c:if test="${fn:length(row[2]) > 0}"> checked</c:if>> ${row[1]}</label></br>
</c:forEach>
</p>
<p>
<b>Order</b></br>
<c:forEach var="row" items="${order}">
<label><input name="order" type="radio" value="${row[0]}" <c:if test="${fn:length(row[2]) > 0}"> checked</c:if>> ${row[1]}</label></br>
</c:forEach>
</p>
<p>
<input type="submit" value="Update">
</p>
</form>
</div>

<div style="overflow:hidden;">
<style>
table {
  border-spacing: 10px;
}
</style>
<table>
<thead>
<tr>
<th>Name</th>
<th>Tags</th>
<th>Type</th>
<th>Level</th>
</tr>
</thead>
<tbody>
<c:forEach var="row" items="${results}">
<tr>
<td><a href="${row[0]}">${row[1]}</a></td>
<td>${row[2]}</td>
<td>${row[3]}</td>
<td>${row[4]}</td>
</tr>
</c:forEach>
</tbody>
</table>
</div>
</div>

    </div>
  </div>
  <div class="bottom" id="bottom">
    <%@ include file="footer.jsp"%>
  </div>
</body>
</html>
