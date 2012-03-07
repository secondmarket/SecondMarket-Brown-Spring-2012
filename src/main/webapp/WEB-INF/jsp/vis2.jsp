<%@ include file="/WEB-INF/jsp/include.jsp" %>
<html>
  <head><title>Visualization 2</title></head>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["treemap"]});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        // Create and populate the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string','FinancialOrg');
        data.addColumn('string','Parent');
		data.addColumn('number','Investments Made');
		data.addColumn('number', 'Market increase/decrease (color)');
		data.addRow(["Financial Organizations",null,0,0]);
		data.addRow(["Under $500 Million","Financial Organizations",0,0]);
		data.addRow(["Under $100 Million","Under $500 Million",0,0]);
		
		var curryear = new Date().getFullYear();
		var yearlimit = 5;
		var i=0;
		<c:forEach items="${financialorgs}" var="fo">
			i++;
			var money=0.0;
			var name="<c:out value="${fo.permalink}"/>";
			<c:forEach items="${fo.investments}" var="investment">
				var funyear = <c:out value="${investment.year}"/>;
				if((curryear-funyear)<5 && (curryear-funyear)>0){
					money = money+<c:out value="${investment.investmentAmount}"/>;
				}
			</c:forEach>
			
			if(money<100000000){data.addRow([name, "Under $100 Million",money,i]);}
			else if(money<500000000){data.addRow([name, "Under $500 Million",money,i]);}
			else{data.addRow([name, "Financial Organizations",money,i]);}
		</c:forEach>			
        // Create and draw the visualization.
        var tree = new google.visualization.TreeMap(document.getElementById('chart_div'));
        
			
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