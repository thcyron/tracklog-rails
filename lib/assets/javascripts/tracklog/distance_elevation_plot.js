Tracklog.DistanceElevationPlot = function(container, tracksFetcher, distanceUnits) {
  this.container     = container;
  this.tracksFetcher = tracksFetcher;
  this.distanceUnits = distanceUnits;

  this.drawPlot();
};

Tracklog.DistanceElevationPlot.prototype.drawPlot = function() {
  var data = [["Distance", "Elevation"]],
      distance = 0,
      minElevation = Infinity;

  this.tracksFetcher.tracks.forEach(function(track) {
    data.push([distance / 1000, track.segments[0].start.elevation]);
    distance += track.segments[0].distance;

    minElevation = Math.min(minElevation, track.segments[0].start.elevation);

    track.segments.forEach(function(segment) {
      data.push([distance / 1000, segment.end.elevation]);
      distance += segment.distance;
      minElevation = Math.min(minElevation, segment.end.elevation);
    });
  });

  data = google.visualization.arrayToDataTable(data);

  new google.visualization.NumberFormat({
    pattern: "#.## km"
  }).format(data, 0);

  new google.visualization.NumberFormat({
    pattern: "# m"
  }).format(data, 1);

  var chart = new google.visualization.LineChart(document.getElementById(this.container));

  chart.draw(data, {
    title: "Distance–Elevation Profile",
    colors: ["green"],
    backgroundColor: {
      strokeWidth: 1,
      stroke: "#ddd",
    },
    legend: {
      position: "none"
    },
    vAxis: {
      title: "Elevation"
    },
    hAxis: {
      title: "Distance"
    }
  });
};
