// Implements the Douglas–Peucker algorithm.
Bikelog.DouglasPeucker = {
  reduce: function(points, epsilon) {
    if (points.length <= 2) {
      return points;
    }

    function distance(x, y, m, t) {
      var dt = Math.abs(t - y + m * x),
          phi = 0.5 * Math.PI - Math.atan(m * Math.PI / 180);

      return Math.sin(phi) * dt;
    }

    var m = (points.slice(-1)[0][1] - points[0][1]) / (points.slice(-1)[0][0] - points[0][0]),
        t = points[0][1] - m * points[0][0],
        dmax = -1, index = -1;

    for (var i = 1; i < points.length - 2; i++) {
      var d = distance(points[i][0], points[i][1], m, t);

      if (d > dmax) {
        dmax = d;
        index = i;
      }
    }

    if (dmax >= epsilon) {
      var res1 = Bikelog.DouglasPeucker.reduce(points.slice(0, index), epsilon),
          res2 = Bikelog.DouglasPeucker.reduce(points.slice(index), epsilon);

      return res1.concat(res2.slice(1));
    } else {
      return [points[0], points.slice(-1)[0]];
    }
  }
}
