Bikelog.Map = {
  setup: function(container, path) {
    var map = new google.maps.Map(document.getElementById(container), {
      "mapTypeId": google.maps.MapTypeId.TERRAIN,
      "mapTypeControlOptions": {
        "style": google.maps.MapTypeControlStyle.DROPDOWN_MENU
      }
    });

    var bounds = new google.maps.LatLngBounds;

    $.getJSON(path, function(tracks) {
      for (var i = 0; i < tracks.length; i++) {
        var line = new google.maps.Polyline({
              "strokeColor": "#ff0000",
              "strokeOpacity": 0.6,
              "strokeWidth": 4
            }),
            points = [];

        line.setMap(map);

        for (var j = 0; j < tracks[i].length; j++) {
          var trackpoint = tracks[i][j],
              point = new google.maps.LatLng(trackpoint[0], trackpoint[1]);

          if (i == 0 && j == 0) {
            startMarker = new google.maps.Marker({
              position: point,
              map: map,
              icon: '/assets/start.png'
            });
          }
          else if (i == tracks.length - 1 && j == tracks[i].length - 1) {
            endMarker = new google.maps.Marker({
              position: point,
              map: map,
              icon: '/assets/end.png'
            });
          }
          
          points.push(point);
          bounds.extend(point);
        }

        line.setPath(points);
        map.fitBounds(bounds);
      }
    });
  }
}
