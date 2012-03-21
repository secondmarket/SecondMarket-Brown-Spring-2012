<%@ include file="/WEB-INF/jsp/include.jsp" %>

<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
      html { height: 100% }
      body { height: 100%; margin: 0; padding: 0 }
      #map_canvas { height: 100% }
    </style>
    <script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCL6xjh4GQqtL4YHsU1a2FPmLysU93ntO0&sensor=false">
    </script>
    <script type="text/javascript" src="/js/markerclusterer.js"></script>
    <script type="text/javascript" src="/js/infobox.js"></script>
    <script type="text/javascript">
      var map;
      var geocoder;
      var mc;
      
      function initialize() {
        var myOptions = {
          center: new google.maps.LatLng(40.0, -100.0),
          zoom: 4,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map_canvas"),
            myOptions);
        geocoder = new google.maps.Geocoder();
        var markers = [];
        <c:forEach items="${companies}" var="company">
          <c:if test="${!empty company.offices}"> 
            var location = {};
            <c:choose>
              <c:when test="${company.offices[0].latitude != 0}">
                var latLong = new google.maps.LatLng(<c:out value="${company.offices[0].latitude}"/>, 
                	<c:out value="${company.offices[0].longitude}"/>);
                var radius = <c:out value="${company.totalMoneyRaised} / 1000"/>;
                var circle = new google.maps.Circle({
                  'center': latLong,
                  'fillColor': '#aaffaa',
                  'fillOpacity': 0.5,
                  'radius': radius,
                  'strokeColor': '#000000',
                  'strokeOpacity': 0.7,
                  'strokeWeight': 1 });
                //circle.setMap(map);
                var marker = new google.maps.Marker({
                  'position': latLong,
                  'title': "<c:out value="${company.name}"/>" });
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
                    'content': "<h3><c:out value="${company.name}"/></h3> \
                    			<h4>Money raised: <fmt:formatNumber value="${company.totalMoneyRaised}" type="currency" /></h4>"
                  });
                  infoBox.open(map, this);
                });
                markers.push(marker);
              </c:when>
              <c:otherwise>
                <c:if test="${!empty company.offices[0].city}">
                  var address = "<c:out value="${company.offices[0].city}"/>";
                  <c:if test="${!empty company.offices[0].state}">
                    address += "<c:out value="${company.offices[0].state}"/>";
                  </c:if>
                  geocoder.geocode({'address': address}, function(results, status) {
                    if (status == google.maps.GeocoderStatus.OK) {
                      var latLong = results[0].geometry.location;
                      // map.setCenter(latLong);
                      var marker = new google.maps.Marker({
                      	'position': latLong, 
                      	'title': "<c:out value="${company.name}"/>" });
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
    </script>
  </head>
  <body onload="initialize()">
    <div id="map_canvas" style="width:100%; height:100%"></div>
  </body>
</html>