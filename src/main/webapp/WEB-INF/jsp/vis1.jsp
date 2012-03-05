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
		data.addRow(["Under $20 Million","Companies",0,0]);
		data.addRow(["Under $5 Million","Under $20 Million",0,0]);
		
		var i=0;
		
    	<c:forEach items="${companies}" var="company">
  			i++;
  			if(<c:out value="${company.totalMoneyRaised}"/>==0){}
  			else if(<c:out value="${company.totalMoneyRaised}"/><5000000){
  				data.addRow(["<c:out value="${company.name}"/>", "Under $5 Million",<c:out value="${company.totalMoneyRaised}"/>,i]);}
  			else if(<c:out value="${company.totalMoneyRaised}"/><20000000){
  				data.addRow(["<c:out value="${company.name}"/>", "Under $20 Million",<c:out value="${company.totalMoneyRaised}"/>,i]); }
  			else{data.addRow(["<c:out value="${company.name}"/>", "Companies",<c:out value="${company.totalMoneyRaised}"/>,i]);}
  		</c:forEach>
			
        // Create and draw the visualization.
        var tree = new google.visualization.TreeMap(document.getElementById('chart_div'));
        
        function selectHandler(e) {
        	var selection = tree.getSelection()[0];
			window.location="/companies/"+data.getValue(selection.row,0).toLowerCase()+".htm"
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