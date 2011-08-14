Bikelog.DistanceElevationPlot = function(container, tracksFetcher, distanceUnits) {
  this.container     = container;
  this.tracksFetcher = tracksFetcher;
  this.distanceUnits = distanceUnits;

  this.drawPlot();
};

Bikelog.DistanceElevationPlot.prototype.drawPlot = function() {
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

  data = Bikelog.DouglasPeucker.reduce(data, 0.5);

  new Highcharts.Chart({
    chart: {
      renderTo: this.container,
      defaultSeriesType: "area"
    },
    title: {
      text: "Distance–Elevation Profile"
    },
    legend: {
      enabled: false
    },
    xAxis: {
      title: {
        text: "Distance"
      },
      labels: {
        formatter: function() {
          if (this.distanceUnits == "imperial") {
            return this.value.to_miles().round() + " miles";
          } else {
            return this.value.to_kilometers().round() + " km";
          }
        }
      }
    },
    yAxis: {
      title: {
        text: "Elevation"
      },
      labels: {
        formatter: function() {
          if (this.distanceUnits == "imperial") {
            return this.value.to_feet().round() + " ft";
          } else {
            return this.value.round() + " m";
          }
        }
      },
      min: minElevation
    },
    tooltip: {
      enabled: false
    },
    plotOptions: {
      area: {
        fillColor: "rgba(0,160,0,.2)",
        shadow: false,
        marker: {
          enabled: false
        }
      }
    },
    series: [
      {
        data: data
      }
    ]
  });
};
