//= require highcharts/highcharts
//= require bikelog/highcharts-theme
//= require bikelog/douglas-peucker
//= require bikelog/distance-elevation-plot
//= require bikelog/map
//= require bikelog/tabs

$(function() {
  $("#track-rename-pane input[type='text']").keyup(function() {
    var e = $("#track-name"),
        name = $.trim($(this).val());

    if (name.length > 0) {
      e.text(name);
    } else {
      e.text(e.attr("data-default-name"));
    }
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
