<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head><title><c:out value="${company.name}" /></title></head>
  <body>
    <h1><c:out value="${company.name}" /></h1>
    <img src="http://crunchbase.com/<c:out value="${company.imageUrl}" />"</img>
    <p>Total money raised: $<c:out value="${company.totalMoneyRaised}" /></p>
  </body>
</html>