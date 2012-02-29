<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head><title>Company list</title></head>
  <body>
    <h1>Companies</h1>
    <ul>
    <c:forEach items="${companies}" var="company">
      <li><c:out value="${company.name}" /></li>
    </c:forEach>
    </ul>
  </body>
</html>