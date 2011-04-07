if (!window["Bikelog"]) {
  window["Bikelog"] = {};
}

Bikelog.Tabs = {
  init: function() {
    var isFirstTab = true;

    $("div.tabs").each(function() {
      var tabs = [];

      $(this).find("div.tab").each(function() {
        if (!isFirstTab) {
          $(this).css("display", "none");
        } else {
          isFirstTab = false;
        }

        tabs.push({
          id: $(this).attr("id"),
          title: $(this).find("h2:first").text()
        });
      });

      Bikelog.Tabs.createTabBar(this, tabs);
    });
  },

  createTabBar: function(container, tabs) {
    var ol = $("<ol>");

    for (var i = 0; i < tabs.length; i++) {
      var tab = tabs[i],
          li = $("<li>");

      li.text(tab.title);
      li.attr("data-tab-id", tab.id);
      li.click(Bikelog.Tabs.clickHandler);

      ol.append(li);
    }

    ol.find("li:first").addClass("selected");
    ol.addClass("tab-bar");

    $(container).find("div.tab:first").before(ol);
  },

  clickHandler: function(event) {
    var target = $(event.target).first(),
        tabId = target.attr("data-tab-id");

    target.parent().find("li").removeClass("selected");
    target.addClass("selected");

    target.parent().parent().find(".tab").each(function() {
      if ($(this).attr("id") == tabId) {
        $(this).css("display", "block");
      } else {
        $(this).css("display", "none");
      }
    });
  }
};

$(Bikelog.Tabs.init);
