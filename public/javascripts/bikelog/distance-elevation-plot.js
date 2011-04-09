Bikelog.DistanceElevationPlot = {
  setup: function(container, path) {
    $.getJSON(path, function(data) {
      var distanceElevationData = [],
          epsilon = 0.5;

      for (var i = 0; i < data.length; i++) {
        distanceElevationData.push([data[i].distance, data[i].elevation]);
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
              return this.value / 1000 + ' km';
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
               return this.value + ' m';
            }
          }
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
