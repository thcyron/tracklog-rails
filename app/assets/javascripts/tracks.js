//= require highcharts/highcharts
//= require bikelog/highcharts_theme
//= require bikelog/douglas_peucker
//= require bikelog/tracks_fetcher
//= require bikelog/distance_elevation_plot
//= require bikelog/haversine
//= require bikelog/map

$(function() {
  $("#track-rename-pane input[type='text']").keyup(function() {
    var e = $("#track-name"),
        name = $.trim($(this).val());

    if (name.length == 0) {
      name = e.attr("data-default-name");
    }

    e.text(name);
    $("head title").text(name + " – Bikelog");
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
