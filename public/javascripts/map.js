var map;

function setupMap(element, path) {
  map = new google.maps.Map(document.getElementById(element), {
    "mapTypeId": google.maps.MapTypeId.TERRAIN,
    "mapTypeControlOptions": {
      "style": google.maps.MapTypeControlStyle.DROPDOWN_MENU
    }
  });

  var bounds = new google.maps.LatLngBounds;

  $.getJSON(path, function(tracks) {
    for (var i = 0; i < tracks.length; i++) {
      var track = tracks[i],
          line = new google.maps.Polyline({
            "strokeColor": "#f00",
            "strokeOpacity": 0.6,
            "strokeWidth": 4
          }),
          points = [];

      line.setMap(map);

      for (var j = 0; j < track.length; j++) {
        var trackpoint = track[j],
            point = new google.maps.LatLng(trackpoint[0], trackpoint[1]);

        points.push(point);
        bounds.extend(point);
      }

      line.setPath(points);
      map.fitBounds(bounds);
    }
  });
}
