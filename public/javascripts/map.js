var map;

function setupMapForLog(element, log_id) {
  map = new google.maps.Map(document.getElementById(element), {
    "mapTypeId": google.maps.MapTypeId.TERRAIN
  });

  var bounds = new google.maps.LatLngBounds;
    
  $.getJSON("/logs/" + log_id + "/tracks", function(data) {
    data.forEach(function(track) {
      var line = new google.maps.Polyline({
            "strokeColor": "#f00",
            "strokeOpacity": 0.6,
            "strokeWidth": 4
          }),
          points = [];

      line.setMap(map);

      track.forEach(function(trackpoint) {
        var point = new google.maps.LatLng(trackpoint[0], trackpoint[1]);
        points.push(point);
        bounds.extend(point);
      });
    
      line.setPath(points);
      map.fitBounds(bounds);
    });
  });
}
