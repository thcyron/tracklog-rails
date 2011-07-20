Bikelog.haversine = function(start, end) {
  var r = 6371, dlat, dlon, a, c;

  dlat = (end.latitude - start.latitude) * Math.PI / 180;
  dlon = (end.longitude - start.longitude) * Math.PI / 180;

  a = Math.sin(dlat / 2) * Math.sin(dlat / 2) +
      Math.cos(start.latitude * Math.PI / 180) *
      Math.cos(end.latitude * Math.PI / 180) *
      Math.sin(dlon / 2) * Math.sin(dlon / 2);
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return r * c * 1000;
};
