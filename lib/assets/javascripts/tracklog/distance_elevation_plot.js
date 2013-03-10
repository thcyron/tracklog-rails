Tracklog.DistanceElevationPlot = function(container, tracksFetcher, distanceUnits) {
  this.container     = container;
  this.tracksFetcher = tracksFetcher;
  this.distanceUnits = distanceUnits;

  this.drawPlot();
};

Tracklog.DistanceElevationPlot.prototype.drawPlot = function() {
  var data = [],
      distance = 0,
      minElevation = Infinity;

  this.tracksFetcher.tracks.forEach(function(track) {
    data.push([distance, track.segments[0].start.elevation]);
    distance += track.segments[0].distance;

    minElevation = Math.min(minElevation, track.segments[0].start.elevation);

    track.segments.forEach(function(segment) {
      data.push([distance, segment.end.elevation]);
      distance += segment.distance;
      minElevation = Math.min(minElevation, segment.end.elevation);
    });
  });

  var $container = $(this.container),
      margin = { top: 30, right: 0, bottom: 30, left: 60 },
      width = $container.width() - margin.left - margin.right,
      height = $container.height() - margin.top - margin.bottom;

  var x = d3.scale.linear().range([0, width]),
      y = d3.scale.linear().range([height, 0]);

  var xAxis = d3.svg.axis().scale(x).orient("bottom"),
      yAxis = d3.svg.axis().scale(y).orient("left");

  var line = d3.svg.line()
    .x(function(d) { return x(d[0]); })
    .y(function(d) { return y(d[1]); });

  var svg = d3.select(this.container).append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  x.domain(d3.extent(data, function(d) { return d[0]; }));
  y.domain(d3.extent(data, function(d) { return d[1]; }));

  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);

  svg.append("path")
    .datum(data)
    .attr("class", "line")
    .attr("d", line);
};
