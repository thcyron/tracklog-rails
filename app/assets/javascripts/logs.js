//= require tracklog/douglas_peucker
//= require tracklog/tracks_fetcher
//= require tracklog/distance_elevation_plot
//= require tracklog/haversine
//= require tracklog/map

$(function() {
  $("#log-tags-pane .close").click(function() {
    $("#log-tags-pane").fadeOut("fast");
    $("#log-tags-pane form").submit();
  });

  $("#log-tags-pane form").submit(function() {
    $("#log-tags-pane").fadeOut("fast");
  });

  $("#log-tags-link").click(function() {
    $("#log-tags-pane").fadeIn("fast");
    $("#log-tags-pane input[type='text']").focus();
    return false;
  });
});
