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
   	 google.load('visualization', '1', {'packages': ['geochart']});
     google.setOnLoadCallback(drawMarkersMap);

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
		
		var first = false;
		<c:forEach items="${company.offices}" var="office">
			if(!first){
				first = true;
				var city = "<c:out value="${office.city}"/>";
				var state =  "<c:out value="${office.state}"/>";
				var country = "<c:out value="${office.country}"/>";
			}
		</c:forEach>
		
		if(state!="" && city!=""){
			city = city + " " + state;
		}
		
		if(country=="USA"){
			if(city!=""){
				if(totalmoney[city]!=null){
					totalmoney[city] = totalmoney[city] + money;
					count[city] = count[city] + 1;
				}
				else{
					totalmoney[city] = money;
					count[city] = 1;
				}
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

      var chart = new google.visualization.GeoChart(document.getElementById('chart_div'));
      chart.draw(data, options);
    };
       
    </script>

  <body>
  	<div id="chart_div" style="width: 900px; height: 600px;"></div>
  </body>
</html>