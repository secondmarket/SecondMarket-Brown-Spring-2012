<%@ include file="/WEB-INF/jsp/include.jsp" %>
<html>
  <head>
    <link rel="stylesheet" href="/css/blueprint/screen.css" type="text/css" media="screen, projection">
	<link rel="stylesheet" href="/css/blueprint/print.css" type="text/css" media="print">
	<!--[if lt IE 8]>
  	<link rel="stylesheet" href="/css/blueprint/ie.css" type="text/css" media="screen, projection">
	<![endif]-->
    <title>Visualization 1</title>
  </head>
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
          headerHeight: 15,
          fontColor: 'black',
          showScale: true});
        }

       
    </script>

  <body>
  	<div id="chart_div" style="width: 1500px; height: 1000px;"></div>
  </body>
</html>