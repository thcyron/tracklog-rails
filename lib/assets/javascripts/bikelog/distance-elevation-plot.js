Bikelog.DistanceElevationPlot = {
  setup: function(container, path, distance_units) {
    $.getJSON(path, function(data) {
      var distanceElevationData = [],
          epsilon = 0.5;

      for (var i = 0; i < data.points.length; i++) {
        distanceElevationData.push([data.points[i].distance, data.points[i].elevation]);
      }

      while (distanceElevationData.length > 500) {
        distanceElevationData = Bikelog.DouglasPeucker.reduce(distanceElevationData, epsilon);
        epsilon += 0.25;
      }

      new Highcharts.Chart({
        chart: {
          renderTo: container,
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
              if (distance_units == "imperial") {
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
          tickInterval: 200,
          labels: {
            formatter: function() {
              if (distance_units == "imperial") {
                return this.value.to_feet().round() + " ft";
              } else {
                return this.value.round() + " m";
              }
            }
          },
          min: data.minElevation
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
            data: distanceElevationData
          }
        ]
      });
    });
  }
}
