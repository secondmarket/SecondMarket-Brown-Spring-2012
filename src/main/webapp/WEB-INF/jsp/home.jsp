<%@ include file="/WEB-INF/jsp/include.jsp" %>

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
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/js/autocomplete.js"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["treemap", "geochart"]});
      google.setOnLoadCallback(drawAll);
      
      function drawAll() {
      	drawChart();
      	drawMarkersMap();
      }
      
      function drawChart() {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string','Company');
        data.addColumn('string','Parent');
		data.addColumn('number','Funding Recieved');
		data.addColumn('number', 'Market increase/decrease (color)');
		data.addRow(["Companies",null,0,0]);
		data.addRow(["Under $300 Million","Companies",0,0]);
		data.addRow(["Under $100 Million","Under $300 Million",0,0]);
		
		var curryear = new Date().getFullYear();
		var yearlimit = 5;
		var i=0;
		var permalinks = {};
		<c:forEach items="${companies}" var="company">
			i++;
			var money=0.0;
			permalinks["<c:out value="${company.name}"/>"] = "<c:out value="${company.permalink}"/>";
			var name="<c:out value="${company.name}"/>";
			<c:forEach items="${company.fundingRounds}" var="round">
				var funyear = <c:out value="${round.year}"/>;
				if((curryear-funyear)<5 && (curryear-funyear)>0){
					money = money+<c:out value="${round.raisedAmount}"/>;
				}
			</c:forEach>
			
			if(money<100000000){data.addRow([name, "Under $100 Million",money,i]);}
			else if(money<300000000){data.addRow([name, "Under $300 Million",money,i]);}
			else{data.addRow([name, "Companies",money,i]);}
		</c:forEach>			
        // Create and draw the visualization.
        var tree = new google.visualization.TreeMap(document.getElementById('chart_div'));
        
        function selectHandler(e) {
        	var selection = tree.getSelection()[0];
        	var perma = permalinks[data.getValue(selection.row,0)];
        	if(perma!=undefined){window.location="/companies/"+perma+".htm"}
		}
        google.visualization.events.addListener(tree,'select',selectHandler);
			
			
        tree.draw(data, {
          minColor: '#188f28',
          midColor: '#8f2818',
          maxColor: '#29198f',
          headerHeight: 0,
          fontColor: 'black',
          showScale: false});
      }
      
      function drawMarkersMap() {
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'City');
      data.addColumn('number', 'Money Raised');
      data.addColumn('number', 'Number Of Companies');
      
      var totalmoney = {};
      var count = {};
  	  var curryear = new Date().getFullYear();    
  	  
      <c:forEach items="${companies}" var="company">
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
	  
	  for(var key in totalmoney){
	  		data.addRow([key,totalmoney[key],count[key]]);
	  }
		
      var options = {
        region: 'US',
        displayMode: 'markers',
        colorAxis: {colors: ['green', 'blue']}
      };

      var chart = new google.visualization.GeoChart(document.getElementById('map_div'));
      chart.draw(data, options);
    };
       
    </script>
  </head>
  <body>
	<div id="top_bar">
	</div>
	<div class="container">
		<%@ include file="/WEB-INF/jsp/menu.jsp" %>
		<div class="span-22 append-1 prepend-1" id="main_content">
			<div class="span-22 content_box">
				<h3>Top 500 Companies by Funding<h3>
				<h4>Location: USA</h4>
				<h4>Industry: All</h4>
				<div id="chart_div" style="width:880px; height: 500px;"></div>
				<div id="map_div" style="width:880px; height: 500px;"></div>
			</div>
		</div>
		<div class="span-24" id="footer">
		</div>
	</div>
  </body>
</html>