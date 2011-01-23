if (!window["BikeLog"]) {
  window["Bikelog"] = {};
}

Bikelog.ElevationPlot = function(container, path) {
  this.width     = 640;
  this.height    = 200;
  this.maxPoints = this.width;
  this.container = container;
  this.path      = path;
}

Bikelog.ElevationPlot.prototype.draw = function() {
  var that = this;

  $.getJSON(this.path, function(points) {
    that.drawPlot(points);
  });
}

Bikelog.ElevationPlot.prototype.drawPlot = function(points) {
  var that = this,
      orig_points = points;

  console.log("Number of points: " + points.length + " (epsilon=" + this.epsilon + ")");

  while (points.length > this.maxPoints) {
    if (this.epsilon) {
      this.epsilon += 0.5;
    } else {
      this.epsilon = 0.5;
    }

    points = this.reduce(orig_points, this.epsilon);
    console.log("Number of points: " + points.length + " (epsilon=" + this.epsilon + ")");
  }

  var r = Raphael(this.container, this.width, this.height),
      xmax = points.slice(-1)[0][0],
      ymin = points[0][1],
      ymax = points[0][1];

  points.forEach(function(point) {
    if (point[1] < ymin) {
      ymin = point[1];
    }
    if (point[1] > ymax) {
      ymax = point[1];
    }
  });

  var xscale = this.width / xmax,
      yscale = (this.height - 10) / (ymax - ymin + 10),
      line = [],
      background = [];

  points.forEach(function(point) {
    line = line.concat([
      line.length == 0 ? "M" : "L",
      point[0] * xscale,
      that.height + ymin * yscale - point[1] * yscale - 10
    ]);
  });

  background = line.slice(0);
  background = background.concat(["L", this.width, this.height]);
  background = background.concat(["L", 0, this.height]);
  background.push("Z");

  r.path(background.join(" ")).attr({
    "fill": "green",
    "fill-opacity": 0.2,
    "stroke": "none"
  });

  r.path(line.join(" ")).attr({
    "stroke": "green",
    "stroke-width": 1.5,
    "stroke-linejoin": "round"
  });
}

// Implements the Douglas–Peucker algorithm.
Bikelog.ElevationPlot.prototype.reduce = function(points, epsilon) {
  if (points.length <= 2) {
    return points;
  }

  var m = (points.slice(-1)[0][1] - points[0][1]) / (points.slice(-1)[0][0] - points[0][0]),
      t = points[0][1] - m * points[0][0],
      dmax = -1, index = -1;

  for (var i = 1; i < points.length - 2; i++) {
    var d = this.distance(points[i][0], points[i][1], m, t);

    if (d > dmax) {
      dmax = d;
      index = i;
    }
  }

  if (dmax >= epsilon) {
    var res1 = this.reduce(points.slice(0, index), epsilon),
        res2 = this.reduce(points.slice(index), epsilon);

    return res1.concat(res2.slice(1));
  } else {
    return [points[0], points.slice(-1)[0]];
  }
},

Bikelog.ElevationPlot.prototype.distance = function(x, y, m, t) {
  var dt = Math.abs(t - y + m * x),
      phi = 0.5 * Math.PI - Math.atan(m * Math.PI / 180);

  return Math.sin(phi) * dt;
}
