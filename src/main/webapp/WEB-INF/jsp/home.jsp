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
    <title>Crunchbase Data Visualizations</title>

	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["treemap"]});
      google.setOnLoadCallback(drawChart);
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

       
    </script>
  </head>
  <body>
	<div id="top_bar">
	</div>
	<div class="container">
	    <div class="span-24" id="header">
	    	<ul id="menu">
				<li><a href="/home.htm">Home</a></li>
				<li><a href="#" class="drop">Industry</a>
					<div class="dropdown_3columns">
						<div class="col_1">
							<ul>
								<li><a href="/industry/advertising.htm">Advertising</a></li>
								<li><a href="/industry/biotech.htm">BioTech</a></li>
								<li><a href="/industry/cleantech.htm">CleanTech</a></li>
								<li><a href="/industry/hardware.htm">Consumer Electronics/Devices</a></li>
								<li><a href="/industry/web.htm">Consumer Web</a></li>
								<li><a href="/industry/ecommerce.htm">eCommerce</a></li>
								<li><a href="/industry/education.htm">Education</a></li>
							</ul>
						</div>
						<div class="col_1">
							<ul>
								<li><a href="/industry/enterprise.htm">Enterprise</a></li>
								<li><a href="/industry/games_video.htm">Games, Video and Entertainment</a></li>
								<li><a href="/industry/legal.htm">Legal</a></li>
								<li><a href="/industry/mobile.htm">Mobile/Wireless</a></li>
								<li><a href="/industry/network_hosting.htm">Network/Hosting</a></li>
								<li><a href="/industry/consulting.htm">Consulting</a></li>
							</ul>
						</div>
						<div class="col_1">
							<ul>
								<li><a href="/industry/public_relations.htm">Communications</a></li>
								<li><a href="/industry/search.htm">Search</a></li>
								<li><a href="/industry/security.htm">Security</a></li>
								<li><a href="/industry/semiconductor.htm">Semiconductor</a></li>
								<li><a href="/industry/software.htm">Software</a></li>
								<li><a href="/industry/other.htm">Other</a></li>
							</ul>
						</div>
					</div>
				</li>
				<li><a href="#" class="drop">Location</a>
					<div class="dropdown_3columns">
						<div class="col_1">
						</div>
						<div class="col_1">
						</div>
						<div class="col_1">
						</div>
					</div>
				</li>
			</ul>
	    </div>
		<div class="span-24" id="fix_header"></div>
		<div class="span-22 append-1 prepend-1" id="main_content">
			<div class="span-22 content_box">
				<h3>Top 500 Companies by Funding<h3>
				<h4>Location:USA</h4>
				<h4>Industry:All</h4>
				<div id="chart_div" style="width:880px; height: 500px;"></div>
			</div>
		</div>
		<div class="span-24" id="footer">
		</div>
	</div>
  </body>
</html>