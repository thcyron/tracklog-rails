Bikelog.haversine = function(start, end) {
  var r = 6371,
      dlat = (end.lat() - start.lat()) * Math.PI / 180,
      dlng = (end.lng() - start.lng()) * Math.PI / 180,
      a = Math.sin(dlat / 2) * Math.sin(dlat / 2) +
          Math.cos(start.lat() * Math.PI / 180) * Math.cos(end.lat() * Math.PI / 180) *
          Math.sin(dlng / 2) * Math.sin(dlng / 2),
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return r * c * 1000;
}
