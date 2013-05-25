Tracklog.DashboardActivityPlots = {
  setup: function(distance_container, duration_container, path, distance_units) {
    $.getJSON(path, function(data) {
      var distanceData = [["Month", "Distance"]],
          durationData = [["Month", "Duration"]];

      for (var i = data.length - 1; i >= 0; i--) {
        distanceData.push([data[i].month, data[i].distance / 1000]);
        durationData.push([data[i].month, data[i].duration / 3600.0]);
      }

      distanceData = google.visualization.arrayToDataTable(distanceData);
      durationData = google.visualization.arrayToDataTable(durationData);

      new google.visualization.NumberFormat({
        pattern: "#.## km"
      }).format(distanceData, 1);

      new google.visualization.NumberFormat({
        pattern: "#.# h"
      }).format(durationData, 1);

      var chart = new google.visualization.LineChart(document.getElementById(distance_container));

      chart.draw(distanceData, {
        title: "12-Month Activity by Distance",
        colors: ["green"],
        backgroundColor: {
          strokeWidth: 1,
          stroke: "#ddd",
        },
        legend: {
          position: "none"
        },
        vAxis: {
          title: "Distance"
        },
        hAxis: {
          title: "Month"
        }
      });

      chart = new google.visualization.LineChart(document.getElementById(duration_container));

      chart.draw(durationData, {
        title: "12-Month Activity by Duration",
        colors: ["green"],
        backgroundColor: {
          strokeWidth: 1,
          stroke: "#ddd",
        },
        legend: {
          position: "none"
        },
        vAxis: {
          title: "Duration"
        },
        hAxis: {
          title: "Month"
        }
      });
    });
  }
}
