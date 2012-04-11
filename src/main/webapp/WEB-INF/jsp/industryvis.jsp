<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page import="java.io.*,java.util.*" %>

<%
String location = request.getQueryString();
String industry = ""+request.getAttribute("javax.servlet.forward.request_uri");
industry = industry.substring("/industry/".length(),industry.indexOf('.')).toLowerCase();
HttpSession session=request.getSession(true);
session.setAttribute( "industry", industry );
session.setAttribute("location", location);

%>

<html>
  <head>
    <link rel="stylesheet" href="/css/blueprint/screen.css" type="text/css" media="screen, projection">
    <link rel="stylesheet" href="/css/blueprint/print.css" type="text/css" media="print">
    <!--[if lt IE 8]>
    <link rel="stylesheet" href="/css/blueprint/ie.css" type="text/css" media="screen, projection">
    <![endif]-->
    <link rel="stylesheet" href="/css/style.css" type="text/css" media="all">
    <link rel="stylesheet" href="/css/menu.css" type="text/css" media="all">
    <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/ui-lightness/jquery-ui.css">
    <title>Crunchbase Data Visualizations</title>
 
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCL6xjh4GQqtL4YHsU1a2FPmLysU93ntO0&sensor=false">
    </script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/js/markerclusterer.js"></script>
    <script type="text/javascript" src="/js/infobox.js"></script>
    <script type="text/javascript" src="/js/autocomplete.js"></script>
    
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["treemap", "corechart", "geochart"]});
      google.setOnLoadCallback(drawAll);
      var curryear = new Date().getFullYear();    
    
      // draw all charts
      function drawAll() {
        drawTreeMap();
        drawMarkersMap();
        drawGoogleMap();
        drawByYearChart();
      }
      
      // draws a chart showing funding by company
      function drawTreeMap() {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string','Company');
        data.addColumn('string','Parent');
		data.addColumn('number','Funding Recieved');
		data.addColumn('number', 'Year Founded');
		data.addRow(["Companies",null,0,0]);
		<c:if test="${fn:length(industrycompanies) gt 50}">
		data.addRow(["Under <fmt:formatNumber value="${industrycompanies[50].fiveYearMoneyRaised}" type="currency"/>","Companies",0,0]);
		<c:if test="${fn:length(industrycompanies) gt 100}">
		data.addRow(["Under <fmt:formatNumber value="${industrycompanies[100].fiveYearMoneyRaised}" type="currency"/>","Under <fmt:formatNumber value="${industrycompanies[50].fiveYearMoneyRaised}" type="currency"/>",0,0]);
		<c:if test="${fn:length(industrycompanies) gt 150}">
		data.addRow(["Under <fmt:formatNumber value="${industrycompanies[150].fiveYearMoneyRaised}" type="currency"/>","Under <fmt:formatNumber value="${industrycompanies[100].fiveYearMoneyRaised}" type="currency"/>",0,0]);
		</c:if>
		</c:if>
		</c:if>
		
		var curryear = new Date().getFullYear();
		var yearlimit = 5;
		var permalinks = {};
		<c:forEach items="${industrycompanies}" var="company">
			var totalMoneyRaised = ${company.totalMoneyRaised};
			var money = ${company.fiveYearMoneyRaised};
			permalinks["${company.name}"] = "${company.permalink}";
			var name = "${company.name}";

		    for (var i = 0; i < 1; ++i) {
		      <c:if test="${fn:length(industrycompanies) gt 150}">
			  if (money<${industrycompanies[150].fiveYearMoneyRaised}) {
			    data.addRow([name, "Under <fmt:formatNumber value="${industrycompanies[150].fiveYearMoneyRaised}" type="currency"/>",money,totalMoneyRaised]);
			    break;
			  }
			  </c:if>
		      <c:if test="${fn:length(industrycompanies) gt 100}">
			  if (money<${industrycompanies[100].fiveYearMoneyRaised}) {
			    data.addRow([name, "Under <fmt:formatNumber value="${industrycompanies[100].fiveYearMoneyRaised}" type="currency"/>",money,totalMoneyRaised]);
			    break;
			  }
			  </c:if>
		      <c:if test="${fn:length(industrycompanies) gt 50}">
			  if (money<${industrycompanies[50].fiveYearMoneyRaised}) {
			    data.addRow([name, "Under <fmt:formatNumber value="${industrycompanies[50].fiveYearMoneyRaised}" type="currency"/>",money,totalMoneyRaised]);
			    break;
			  }
			  </c:if>
			  data.addRow([name, "Companies",money,totalMoneyRaised]);
			  break;
			}
		</c:forEach>			
		
        // Create and draw the visualization.
        var tree = new google.visualization.TreeMap(document.getElementById('chart_div'));
        
        function selectHandler(e) {
          var selection = tree.getSelection()[0];
          var perma = permalinks[data.getValue(selection.row,0)];
          if(perma!=undefined){window.location="/companies/"+perma+".htm"}
        }
        function mouseoverHandler(e) {
          var name = data.getValue(e.row, 0);
          $('#treemapSelection').text(name);
        }
        function mouseoutHandler(e) {
          $('#treemapSelection').text('');
        }

        google.visualization.events.addListener(tree,'select',selectHandler);
        google.visualization.events.addListener(tree,'onmouseover',mouseoverHandler);
        google.visualization.events.addListener(tree,'onmouseout',mouseoutHandler);

        data.sort(2);
        tree.draw(data, {
          minColor: '#bdcc32',
          midColor: '#0fadda',
          maxColor: '#de9927',
          maxColorValue: data.getNumberOfRows() == 0 ? 0 : data.getValue(data.getNumberOfRows() - 1, 2) * .75,
          headerHeight: 0,
          fontColor: 'black',
          showScale: false });
      }

      // draws a chart showing funding geographically
      function drawMarkersMap() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'City');
        data.addColumn('number', 'Money Raised');
        data.addColumn('number', 'Number Of Companies');
      
        var totalmoney = {};
        var count = {};
      
        <c:forEach items="${industrycompanies}" var="company">
          var money=0.0;
        
          <c:forEach items="${company.fundingRounds}" var="round">
            var funyear = <c:out value="${round.year}"/>;
            if((curryear-funyear)<5 && (curryear-funyear)>0){
                money = money+<c:out value="${round.raisedAmount}"/>;
            }
          </c:forEach>
        
          var city = "";
          var state = "";
          var country = "";
          <c:if test="${!empty company.offices}">
            city = "<c:out value="${company.offices[0].city}" />";
            state = "<c:out value="${company.offices[0].state}" />";
            country = "<c:out value="${company.offices[0].country}" />";
          </c:if>
        
          if(state!="" && city!=""){
            city = city + " " + state;
          }
        
          if(country=="USA" && city!="" && money>0){
                if(totalmoney[city]!=null){
                    totalmoney[city] = totalmoney[city] + money;
                    count[city] = count[city] + 1;
                }
                else{
                    totalmoney[city] = money;
                    count[city] = 1;
                }
        }
        </c:forEach>
      
        for(var key in totalmoney) {
          data.addRow([key,totalmoney[key],count[key]]);
        }
        
        var options = {
          region: 'US',
          displayMode: 'markers',
          colorAxis: {colors: ['green', 'blue']}
        };

        var chart = new google.visualization.GeoChart(document.getElementById('map_div'));
        chart.draw(data, options);
      }

      // a geogrpahic visualization using the Google Maps API
      function drawGoogleMap() { 
        var map;
        var geocoder;
        var mc;

        // center over the middle of the US
        var myOptions = {
          center: new google.maps.LatLng(40.0, -100.0),
          zoom: 4,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("googlemaps_div"),
            myOptions);
        geocoder = new google.maps.Geocoder();
        var markers = [];
        <c:forEach items="${industrycompanies}" var="company">
          <c:if test="${!empty company.offices}"> 
            var location = {};
            <c:choose>
              <c:when test="${company.offices[0].latitude != 0 && 
              	company.offices[0].longitude != -95.712891 }">
                var latLong = new google.maps.LatLng(<c:out value="${company.offices[0].latitude}"/>, 
                	<c:out value="${company.offices[0].longitude}"/>);
                /*
                var radius = <c:out value="${company.totalMoneyRaised} / 1000"/>;
                var circle = new google.maps.Circle({
                  'center': latLong,
                  'fillColor': '#aaffaa',
                  'fillOpacity': 0.5,
                  'radius': radius,
                  'strokeColor': '#000000',
                  'strokeOpacity': 0.7,
                  'strokeWeight': 1 });
                circle.setMap(map);
                */
                var marker = new google.maps.Marker({
                  'position': latLong,
                  'title': "<c:out value="${company.name}"/>" });
                marker.totalMoneyRaised = <c:out value="${company.totalMoneyRaised}"/>;

                var infoBox = null;
                google.maps.event.addListener(marker, "click", function() {
                  if (infoBox) infoBox.close();
                  infoBox = new InfoBox({
                  	'alignBottom': true,
                  	'pixelOffset': new google.maps.Size(0, -25),
                      'boxStyle': { 'border': '1px solid gray', 'padding-left': '10px', 
                      'font-family': 'sans-serif', 'color': 'black', 'background-color': '#ddefdd', 
                      'opacity': 0.8 },
                  	'closeBoxMargin': '0px 0px',
                    'content': "<h3><a href='<c:out value="/companies/${company.permalink}.htm"/>'><c:out value="${company.name}"/></a></h3> \
                    			<h4>Industry: <c:out value="${company.industry}"/></h4> \
                    			<h4>Money raised: <fmt:formatNumber value="${company.totalMoneyRaised}" type="currency" /></h4>"
                  });
                  infoBox.open(map, this);
                });
                markers.push(marker);
              </c:when>
              <c:otherwise>
                var address = "<c:out value="${company.offices[0].address}"/>";
                <c:if test="${!empty company.offices[0].city}">
                  address += ", <c:out value="${company.offices[0].city}"/>";
                  <c:if test="${!empty company.offices[0].state}">
                    address += ", <c:out value="${company.offices[0].state}"/>";
                  </c:if>
                  geocoder.geocode({'address': address}, function(results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                      var latLong = results[0].geometry.location;
                      var marker = new google.maps.Marker({
                      	'position': latLong, 
                      	'title': "<c:out value="${company.name}"/>" });
    	              marker.totalMoneyRaised = <c:out value="${company.totalMoneyRaised}"/>;
                      markers.push(marker);
                    }
                  });
                </c:if>
              </c:otherwise>
            </c:choose>
          </c:if>
        </c:forEach>
        
        mc = new MarkerClusterer(map, markers);        
      }

      // draws a chart showing funding by year
      function drawByYearChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Year');
        data.addColumn('number', 'Money Raised');
        var rows = {};
        <c:forEach items="${industrycompanies}" var="company">
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
        </c:forEach>
        data.addRows(jsonToRows(rows));

        var options = {
          title: 'Total Funding to Top Companies',
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
                <h3>Top ${fn:length(industrycompanies)} Companies by Funding<h3>
                <h4>Location: 
                <% 
                    if(location!=null && location.contains("%20")){
                        String beg = location.substring(0,location.indexOf("%20"));
                        String end = location.substring(location.indexOf("%20")+"%20".length());
                        location = beg + " " + end;
                    }
                    if(location!=null){out.println(location);}
                    else{out.println("USA");}               
                %>
                </h4>
                <h4>Industry:
                 <script type="text/javascript">
                    var industry = "<%=industry%>";
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
                 </script>
                </h4>
                <div id="chart_div" class="chart" style="width:880px; height: 500px;"></div>
                <div style="height: 10px"><h4 id="treemapSelection"></h4></div>
            </div>
            <div class="span-22 content_box">
                <div id="map_div" class="chart" style="width:860px; height: 500px;"></div>
            </div>
            <div class="span-22 content_box">
                <div id="googlemaps_div" class="chart" style="width:860px; height: 500px;"></div>
            </div>
            <div class="span-22 content_box">
                <div id="linechart_div" class="chart" style="width:860px; height: 500px;"></div>
            </div>
        </div>
        <div class="span-24" id="footer">
        </div>
    </div>
  </body>
</html>
