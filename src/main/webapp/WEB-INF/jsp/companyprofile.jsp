<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page import="java.io.*,java.util.*" %>

<%
HttpSession session=request.getSession(true);
String location = (String)session.getAttribute("location");
String industry = (String)session.getAttribute("industry");
if (industry == null) industry = "all";
%>

<!DOCTYPE HTML>
<html>
  <head>
    <link rel="stylesheet" href="/css/blueprint/screen.css" type="text/css" media="screen, projection">
	<link rel="stylesheet" href="/css/blueprint/print.css" type="text/css" media="print">
	<!--[if lt IE 8]>
  	<link rel="stylesheet" href="/css/blueprint/ie.css" type="text/css" media="screen, projection">
	<![endif]-->
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/ui-lightness/jquery-ui.css">
	<link rel="stylesheet" href="/css/menu.css" type="text/css" media="all">
	<link rel="stylesheet" href="/css/style.css" type="text/css" media="all">
	<!--Load the AJAX API-->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript" src="/js/autocomplete.js"></script>
    <script type="text/javascript">
      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawCharts);

      var curryear = new Date().getFullYear();    

      function drawCharts() {
          <c:if test="${companies[1]!=null}">
          drawPieChart();
          </c:if>
          drawLineChart();
      }

      <c:if test="${companies[1]!=null}">
      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawPieChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Company');
        data.addColumn('number', 'Funding');
        
     	var permalinks = {};
        <c:forEach var="company" items="${companies}">
			 permalinks["${company.name}"] = "${company.permalink}";
		     data.addRow(['<c:out value="${company.name}"/>',<c:out value="${company.fiveYearMoneyRaised}"/>]);
		</c:forEach>
		
        // Set chart options
        var options = {'title':'<c:out value="${companies[0].name}"/> as compared to competitors by funding',
                       'width':400,
                       'height':300};

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('piechart_div'));

		function selectHandler() {
			var selectedItem = chart.getSelection()[0];
			if(selectedItem){
				var compname = data.getValue(selectedItem.row,0);
				var perma = permalinks[compname];
				if(perma!=undefined){window.location="/companies/"+perma+".htm"}
			}
		}
		
		google.visualization.events.addListener(chart, 'select', selectHandler);
		
        chart.draw(data, options);
      }
      </c:if>

      // draws a chart showing funding by year
      function drawLineChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Year');
        data.addColumn('number', 'Money Raised');
        var rows = {};
        <c:set var="company" value="${companies[0]}"/>
        <c:forEach items="${company.fundingRounds}" var="round">
          var funyear = <c:out value="${round.year}"/>;
          if ((curryear - funyear) < 10 && (curryear - funyear) > 0) {
            if (rows[funyear]) {
              rows[funyear] += <c:out value="${round.raisedAmount}"/>;
            } else {
              rows[funyear] = <c:out value="${round.raisedAmount}"/>;
            }
          }
        </c:forEach>
        data.addRows(jsonToRows(rows));

        var options = {
          title: 'Total Funding by Year',
        };

        var chart = new google.visualization.LineChart(document.getElementById('linechart_div'));
        chart.draw(data, options);
      }

      function jsonToRows(json) {
        var rows = [];
        for (var key in json) {
            rows.push([key, json[key]]);
        }

        return rows;
      }
    </script>
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
				<div class="span-6 append-1 prepend-1">
					<br/>
					<img src="http://crunchbase.com/<c:out value="${companies[0].imageUrl}" />" alt="${companies[0].name}" />
					<br/><br/>
					<div class="header_box"><h3>General information</h3></div>
					<div class="span-3 left">
						<h5>Website</h5>
						<h5>CrunchBase</h5>
						<h5>Industry</h5>
						<h5>Employees</h5>
						<h5>Founded</h5>
					</div>
					<div class="span-3 last left">
						<a href="<c:out value="${companies[0].homepageUrl}"/>"><c:out value="${companies[0].name}"/></a><br/>
						<a href="http://www.crunchbase.com/company/${companies[0].permalink}">Profile</a><br/>
						<a href="/industry/<c:out value="${companies[0].industry}"/>.htm"><script type="text/javascript">
	                    var industry = "<c:out value="${companies[0].industry}"/>";
	                    switch(industry)
	                    {
	                    case "all":
	                        document.write("All");
	                        break;
	                    case "advertising":
	                        document.write("Advertising");
	                        break;
	                    case "biotech":
	                        document.write("BioTech");
	                        break;
	                    case "cleantech":
	                        document.write("CleanTech");
	                        break;
	                    case "hardware":
	                        document.write("Consumer Electronics/Devices");
	                        break;
	                    case "web":
	                        document.write("Consumer Web");
	                        break;
	                    case "ecommerce":
	                        document.write("eCommerce");
	                        break;
	                    case "education":
	                        document.write("Education");
	                        break;
	                    case "enterprise":
	                        document.write("Enterprise");
	                        break;
	                    case "games_video":
	                        document.write("Games, Video and Entertainment");
	                        break;
	                    case "legal":
	                        document.write("Legal");
	                        break;
	                    case "mobile":
	                        document.write("Mobile/Wireless");
	                        break;
	                    case "network_hosting":
	                        document.write("Network/Hosting");
	                        break;
	                    case "consulting":
	                        document.write("Consulting");
	                        break;
	                    case "public_relations":
	                        document.write("Communications");
	                        break;
	                    case "search":
	                        document.write("Search");
	                        break;
	                    case "security":
	                        document.write("Security");
	                        break;
	                    case "semiconductor":
	                        document.write("Semiconductor");
	                        break;
	                    case "software":
	                        document.write("Software");
	                        break;
	                    case "other":
	                        document.write("Other");
	                        break;
	                    default:
	                        document.write("Error");
	                    }
	                 </script></a><br/>
					 <c:out value="${companies[0].numEmployees}"/><br/>
					 <c:out value="${companies[0].yearFounded}"/><br/>
					</div>
				</div>
				<div id="company_description" class="span-13 append-1 last left">
					<br/>
					<h2><c:out value="${companies[0].name}" /></h2>
					<hr/>
					${companies[0].overview}
				</div>
				<hr/>
			    <a href="/industry/<%=industry%>.htm<% if(location!=null){out.println("?"+location);}%>">Back</a>
			</div>
			<c:if test="${companies[1]!=null}">
			<div class="span-22 content_box">
			 	<div id="piechart_div"></div>
			</div>
			</c:if>
			<div class="span-22 content_box">
			 	<div id="linechart_div"></div>
			</div>
		</div>
  </body>
</html>
