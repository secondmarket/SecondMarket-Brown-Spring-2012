<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head><title>Company list</title></head>
  <body>
    <h1>Companies</h1>
    <ul>
    <c:forEach items="${companies}" var="company">
      <li><a href="/companies/<c:out value="${company.permalink}"/>.htm">
      <c:out value="${company.name}"/></a></li>
    </c:forEach>
    </ul>
  </body>
</html>