<%@ include file="/WEB-INF/jsp/include.jsp" %>

<html>
  <head>
    <link rel="stylesheet" href="/css/blueprint/screen.css" type="text/css" media="screen, projection">
	<link rel="stylesheet" href="/css/blueprint/print.css" type="text/css" media="print">
	<!--[if lt IE 8]>
  	<link rel="stylesheet" href="/css/blueprint/ie.css" type="text/css" media="screen, projection">
	<![endif]-->
    <title><c:out value="${company.name}" /></title>
  </head>
  <body>
    <h1><c:out value="${company.name}" /></h1>
    <img src="http://crunchbase.com/<c:out value="${company.imageUrl}" />"</img>
    <p>Total money raised: <fmt:formatNumber value="${company.totalMoneyRaised}" type="currency"/></p>
    <h2>Funding rounds:</h2>
    <ul>
      <c:forEach var="round" items="${company.fundingRounds}">
        <li><c:out value="${round.roundCode}" />: <fmt:formatNumber value="${round.raisedAmount}" type="currency" /></li>
      </c:forEach>
    </ul>
  </body>
</html>