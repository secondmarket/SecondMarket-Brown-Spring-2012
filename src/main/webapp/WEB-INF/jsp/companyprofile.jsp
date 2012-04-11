<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page import="java.io.*,java.util.*" %>

<%
HttpSession session=request.getSession(true);
String location = (String)session.getAttribute("location");
String industry = (String)session.getAttribute("industry");
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
	<script type="text/javascript">
		function htmlDecode(input){
			var e = document.createElement('div');
			e.innerHTML = input;
			return e.childNodes[0].nodeValue;
		}
	</script>
	<c:if test="${companies[1]!=null}">
	<!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">

      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Company');
        data.addColumn('number', 'Funding');
             
        <c:forEach var="company" items="${companies}">
		     data.addRow(['<c:out value="${company.name}"/>',<c:out value="${company.fiveYearMoneyRaised}"/>]);
		</c:forEach>
		
        // Set chart options
        var options = {'title':'<c:out value="${companies[0].name}"/> as compared to competitors by funding',
                       'width':400,
                       'height':300};

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
   </c:if>
    <title><c:out value="${companies[0].name}" /></title>
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
			    <img src="http://crunchbase.com/<c:out value="${companies[0].imageUrl}" />" alt="header image" />
        		<h1><c:out value="${companies[0].name}" /></h1>
        	    <hr />
				<div class="companyprofile">
					<script type="text/javascript">document.write(htmlDecode("<c:out value="${companies[0].overview}"/>"));</script>
		        	<p>Total money raised: <fmt:formatNumber value="${companies[0].totalMoneyRaised}" type="currency"/></p>
		        	<p>Money raised over the last 5 years: <fmt:formatNumber value="${companies[0].fiveYearMoneyRaised}" type="currency"/></p>
		        	<h2>Funding rounds:</h2>
		        	<ul>
		          	<c:forEach var="round" items="${companies[0].fundingRounds}">
		            	<li><c:out value="${round.roundCode}" />: <fmt:formatNumber value="${round.raisedAmount}" type="currency" /></li>
		          	</c:forEach>
		        	</ul>
		        	<a href="http://www.crunchbase.com/company/<c:out value="${companies[0].permalink}"/>">CrunchBase profile</a>
		        </div>
        	    <hr />
		        <a href="/industry/<%=industry%>.htm<% if(location!=null){out.println("?"+location);}%>">Back</a>
			</div>
			<c:if test="${companies[1]!=null}">
			<div class="span-22 content_box">
			 	<div id="chart_div"></div>
			</div>
			</c:if>
		</div>
  </body>
</html>