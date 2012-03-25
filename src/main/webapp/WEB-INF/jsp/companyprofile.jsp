<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page import="java.io.*,java.util.*" %>

<%
String location = request.getQueryString();
String industry = ""+request.getAttribute("javax.servlet.forward.request_uri");
industry = industry.substring("/industry/".length(),industry.indexOf('.')).toLowerCase();
%>


<html>
  <head>
    <link rel="stylesheet" href="/css/blueprint/screen.css" type="text/css" media="screen, projection">
	<link rel="stylesheet" href="/css/blueprint/print.css" type="text/css" media="print">
	<!--[if lt IE 8]>
  	<link rel="stylesheet" href="/css/blueprint/ie.css" type="text/css" media="screen, projection">
	<![endif]-->
	<link rel="stylesheet" href="/css/menu.css" type="text/css" media="all">
	<link rel="stylesheet" href="/css/style.css" type="text/css" media="all">	
    <title><c:out value="${company.name}" /></title>
  </head>
  <body>
	<div id="top_bar">
	</div>
    <div class="container">
	  <%@ include file="/WEB-INF/jsp/menu.jsp" %> 
		<div class="span-22 append-1 prepend-1" id="main_content">
			<div class="span-22 page_header">
			</div>
			<div class="span-22 content_header">
			</div>
			<div class="span-22 content_box">
			    <img src="http://crunchbase.com/<c:out value="${company.imageUrl}" />" alt="header image" />
        		<h1><c:out value="${company.name}" /></h1>
        	    <hr />
		        <p>Total money raised: <fmt:formatNumber value="${company.totalMoneyRaised}" type="currency"/></p>
		        <h2>Funding rounds:</h2>
		        <ul>
		          <c:forEach var="round" items="${company.fundingRounds}">
		            <li><c:out value="${round.roundCode}" />: <fmt:formatNumber value="${round.raisedAmount}" type="currency" /></li>
		          </c:forEach>
		        </ul>
			</div>
		</div>
  </body>
</html>