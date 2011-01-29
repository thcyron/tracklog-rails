if (!window["Bikelog"]) {
  window["Bikelog"] = {};
}

Bikelog.Plot = function(options) {
  this.container = options.container;
  this.width     = parseInt($("#" + this.container).css("width"));
  this.height    = parseInt($("#" + this.container).css("height"));
  this.maxPoints = options.maxPoints || this.width;
  this.graphs    = options.graphs;
  this.r         = Raphael(this.container, this.width, this.height);
}

Bikelog.Plot.prototype.reducePoints = function(points, maxPoints) {
  var epsilon,
      orig_points = points;

  while (points.length > maxPoints) {
    if (epsilon) {
      epsilon += 0.5;
    } else {
      epsilon = 0.5;
    }

    points = this.reduce(orig_points, epsilon);
  }

  return points;
}

Bikelog.Plot.prototype.draw = function() {
  var that = this;

  this.drawGrid();

  this.graphs.forEach(function(graph) {
    that.drawGraph(graph);
  });
}

Bikelog.Plot.prototype.drawGrid = function() {
  var ystep = this.height / 8,
      xstep = this.width / 10;

  /* Frame */
  this.r.path([
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

  /* Vertical lines */
  for (var i = 1; i < 10; i++) {
    this.r.path([
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
    this.r.path([
      "M", 0, Math.round(this.height - ystep * i) + .5,
      "L", this.width, Math.round(this.height - ystep * i) + .5,
      "Z"
    ].join(" ")).attr({
      "stroke": "#eee",
      "stroke-width": 1
    });
  }
}

Bikelog.Plot.prototype.drawGraph = function(graph) {
  var that = this,
      xmax = graph.points.slice(-1)[0][0],
      ymin = graph.points[0][1],
      ymax = graph.points[0][1];

  graph.points = this.reducePoints(graph.points, graph.maxPoints || this.maxPoints);

  graph.points.forEach(function(point) {
    if (point[1] < ymin) {
      ymin = point[1];
    }
    if (point[1] > ymax) {
      ymax = point[1];
    }
  });

  var xscale   = this.width / xmax,
      yscale   = (this.height - 20) / (ymax - ymin),
      linePath = [],
      bgPath   = [];

  graph.points.forEach(function(point) {
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

  if (graph.fill) {
    this.r.path(bgPath.join(" ")).attr({
      "fill": graph.strokeColor,
      "fill-opacity": 0.2,
      "stroke": "none"
    });
  }

  this.r.path(linePath.join(" ")).attr({
    "stroke": graph.strokeColor,
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
