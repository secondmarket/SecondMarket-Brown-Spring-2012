<%@ include file="/WEB-INF/jsp/include.jsp" %>
<html>
  <head><title>Visualization 1</title></head>
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
		
		var i=0;
    	<c:forEach items="${companies}" var="company">
  			i++;
     		data.addRow(["<c:out value="${company.name}"/>", "Companies",<c:out value="${company.totalMoneyRaised}"/>,i]); 
  		</c:forEach>

        // Create and draw the visualization.
        var tree = new google.visualization.TreeMap(document.getElementById('chart_div'));
        tree.draw(data, {
          minColor: '#f00',
          midColor: '#ddd',
          maxColor: '#0d0',
          headerHeight: 15,
          fontColor: 'black',
          showScale: true});
        }
    </script>

  <body>
  	<div id="chart_div" style="width: 2000px; height: 1000px;"></div>
  </body>
</html>