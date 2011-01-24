if (!window["Bikelog"]) {
  window["Bikelog"] = {};
}

Bikelog.Plot = function(options) {
  this.container = options.container;
  this.width     = parseInt($("#" + this.container).css("width"));
  this.height    = parseInt($("#" + this.container).css("height"));
  this.maxPoints = options.maxPoints || this.width;
  this.points    = options.points;
}

Bikelog.Plot.prototype.reducePoints = function() {
  var orig_points = this.points;

  while (this.points.length > this.maxPoints) {
    if (this.epsilon) {
      this.epsilon += 0.5;
    } else {
      this.epsilon = 0.5;
    }

    this.points = this.reduce(orig_points, this.epsilon);
  }
}

Bikelog.Plot.prototype.draw = function() {
  var that = this,
      xmax = this.points.slice(-1)[0][0],
      ymin = this.points[0][1],
      ymax = this.points[0][1],
      r    = Raphael(this.container, this.width, this.height);

  this.reducePoints();

  this.points.forEach(function(point) {
    if (point[1] < ymin) {
      ymin = point[1];
    }
    if (point[1] > ymax) {
      ymax = point[1];
    }
  });

  var xscale   = this.width / xmax,
      yscale   = (this.height - 10) / (ymax - ymin + 10),
      linePath = [],
      bgPath   = [];

  /* Frame */
  r.path([
    "M", .5, .5,
    "L", this.width - .5, .5,
    "L", this.width - .5, this.height - .5,
    "L", .5, this.height - .5,
    "L", .5, .5,
    "Z"
  ].join(" ")).attr({
    "stroke": "#eee",
    "stroke-width": 1
  });

  var ystep = this.height / 8,
      xstep = this.width / 10;

  /* Vertical lines */
  for (var i = 1; i < 10; i++) {
    r.path([
      "M", Math.round(xstep * i) + .5, 0,
      "L", Math.round(xstep * i) + .5, this.height,
      "Z"
    ].join(" ")).attr({
      "stroke": "#eee",
      "stroke-width": 1
    });
  }

  /* Horizontal lines */
  for (var i = 1; i < 8; i++) {
    r.path([
      "M", 0, Math.round(this.height - ystep * i) + .5,
      "L", this.width, Math.round(this.height - ystep * i) + .5,
      "Z"
    ].join(" ")).attr({
      "stroke": "#eee",
      "stroke-width": 1
    });
  }

  this.points.forEach(function(point) {
    linePath = linePath.concat([
      linePath.length == 0 ? "M" : "L",
      point[0] * xscale,
      that.height + ymin * yscale - point[1] * yscale - 10
    ]);
  });

  bgPath = linePath.slice(0);
  bgPath = bgPath.concat(["L", this.width, this.height]);
  bgPath = bgPath.concat(["L", 0, this.height]);
  bgPath.push("Z");

  r.path(bgPath.join(" ")).attr({
    "fill": "green",
    "fill-opacity": 0.2,
    "stroke": "none"
  });

  r.path(linePath.join(" ")).attr({
    "stroke": "green",
    "stroke-width": 1.5,
    "stroke-linejoin": "round"
  });
}

// Implements the Douglas–Peucker algorithm.
Bikelog.Plot.prototype.reduce = function(points, epsilon) {
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

Bikelog.Plot.prototype.distance = function(x, y, m, t) {
  var dt = Math.abs(t - y + m * x),
      phi = 0.5 * Math.PI - Math.atan(m * Math.PI / 180);

  return Math.sin(phi) * dt;
}
