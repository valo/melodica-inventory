// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
window.jQuery = window.$ = require("jquery/dist/jquery.min.js");
window.Tether = require("tether/dist/js/tether.min.js");

require("bootstrap/dist/js/bootstrap.js");
require("bootstrap-year-calendar/js/bootstrap-year-calendar.js");

$(document).ready(function() {
  $("#returnLessModal").on("show.bs.modal", function(event) {
    var button = $(event.relatedTarget);
    var loanReturnUrl = button.data("loan-return-url");
    var maxQuantity = button.data("max-quantity");
    var modal = $(this);

    modal.find("#quantity").val(maxQuantity);
    modal.find("form").attr("action", loanReturnUrl);
    modal.find(".modal-footer .btn-primary").click(function() {
      return modal.find("form").submit();
    });
  });

  $("#currentEvent").on("change", function(event) {
    $(".current_event").submit();
  });

  $("#calendar").calendar({
    style: 'background',
    dataSource: calendarDataSource,
    mouseOnDay: function(e) {
      if(e.events.length > 0) {
        var content = '';

        for(var i in e.events) {
          content += '<div class="event-tooltip-content">'
                     + '<div class="event-name" style="color:' + e.events[i].color + '">' + e.events[i].name + '</div>'
                     + '<div class="event-location">Quantity: ' + e.events[i].quantity + '</div>'
                   + '</div>';
        }

        $(e.element).popover({
          trigger: 'manual',
          container: 'body',
          html:true,
          content: content
        });

        $(e.element).popover('show');
      }
    },
    mouseOutDay: function(e) {
      if(e.events.length > 0) {
        $(e.element).popover('hide');
      }
    },
  });
});
