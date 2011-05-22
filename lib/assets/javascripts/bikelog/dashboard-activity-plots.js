Bikelog.DashboardActivityPlots = {
  setup: function(distance_container, duration_container, path) {
    $.getJSON(path, function(data) {
      var months = [],
          distances = [],
          durations = [];

      for (var i = data.length - 1; i >= 0; i--) {
        months.push(data[i].month);
        distances.push(data[i].distance);
        durations.push(data[i].duration / 3600.0);
      }

      new Highcharts.Chart({
        chart: {
          renderTo: distance_container,
          defaultSeriesType: "line",
          spacingBottom: 25
        },
        title: {
          text: "12-Month Activity by Distance"
        },
        legend: {
          enabled: false
        },
        tooltip: {
          enabled: false
        },
        xAxis: {
          categories: months
        },
        yAxis: {
          title: {
            text: "Distance"
          },
          labels: {
            formatter: function() {
               return this.value / 1000.0 + " km";
            }
          },
          min: 0
        },
        series: [
          {
            name: "Distance",
            data: distances
          }
        ]
      });

      new Highcharts.Chart({
        chart: {
          renderTo: duration_container,
          defaultSeriesType: "line",
          spacingBottom: 25
        },
        title: {
          text: "12-Month Activity by Duration"
        },
        legend: {
          enabled: false
        },
        tooltip: {
          enabled: false
        },
        xAxis: {
          categories: months
        },
        yAxis: {
          title: {
            text: "Duration"
          },
          labels: {
            formatter: function() {
               return this.value + " h";
            }
          },
          min: 0
        },
        series: [
          {
            name: "Duration",
            data: durations
          }
        ]
      });
    });
  }
}
