<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head>
    <link rel="stylesheet" href="/css/blueprint/screen.css" type="text/css" media="screen, projection">
	<link rel="stylesheet" href="/css/blueprint/print.css" type="text/css" media="print">
	<!--[if lt IE 8]>
  	<link rel="stylesheet" href="/css/blueprint/ie.css" type="text/css" media="screen, projection">
	<![endif]-->
    <title>Company list</title>
  </head>
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