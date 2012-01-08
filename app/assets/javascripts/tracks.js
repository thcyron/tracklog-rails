//= require highcharts/highcharts
//= require tracklog/highcharts_theme
//= require tracklog/douglas_peucker
//= require tracklog/tracks_fetcher
//= require tracklog/distance_elevation_plot
//= require tracklog/haversine
//= require tracklog/map

$(function() {
  $("#track-rename-pane input[type='text']").keyup(function() {
    var e = $("#track-name"),
        name = $.trim($(this).val());

    if (name.length == 0) {
      name = e.attr("data-default-name");
    }

    e.text(name);
    $("head title").text(name + " – Tracklog");
  });

  $("#track-rename-pane .close").click(function() {
    $("#track-rename-pane").fadeOut("fast");
    $("#track-rename-pane form").submit();
  });

  $("#track-rename-pane form").submit(function() {
    $("#track-rename-pane").fadeOut("fast");
  });

  $("#track-rename-link").click(function() {
    $("#track-rename-pane").fadeIn("fast");
    $("#track-rename-pane input[type='text']").focus();
    return false;
  });
});
