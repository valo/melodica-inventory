import css from '../css/app.scss';
// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
// import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
window.jQuery = window.$ = require("jquery/dist/jquery.min.js");
window.Tether = require("tether/dist/js/tether.min.js");

require("bootstrap/dist/js/bootstrap.js");
require("bootstrap-year-calendar/js/bootstrap-year-calendar.js");
require('jquery-ui')

function setup_calendar() {
  $("#calendar").calendar({
    style: 'background',
    dataSource: calendarDataSource,
    mouseOnDay: function (e) {
      if (e.events.length > 0) {
        var content = '';

        for (var i in e.events) {
          content += '<div class="event-tooltip-content">'
            + '<div class="event-name" style="color:' + e.events[i].color + '">' + e.events[i].name + '</div>'
            + '<div class="event-location">Quantity: ' + e.events[i].quantity + '</div>'
            + '<div class="event-manager">Manager: ' + e.events[i].manager + '</div>'
            + '</div>';
        }

        $(e.element).popover({
          trigger: 'manual',
          container: 'body',
          html: true,
          content: content
        });

        $(e.element).popover('show');
      }
    },
    mouseOutDay: function (e) {
      if (e.events.length > 0) {
        $(e.element).popover('hide');
      }
    },
  });
}

function setupSearchField() {
  var searchViewDisplayed = false;
  var currentPageHtml = null;
  $('#search').on('submit', function (event) {
    event.preventDefault();
    return false;
  });

  $('#search input').on('input', function (event) {
    if (event.target.value.length > 1) {
      $.get("/search", { q: event.target.value }, function (data) {
        if (!searchViewDisplayed) {
          searchViewDisplayed = true;
          currentPageHtml = $('.container-fluid').html();
        }
        $('.container-fluid').html(data);
      });
    } else {
      if (searchViewDisplayed) {
        searchViewDisplayed = false;
        $('.container-fluid').html(currentPageHtml);
      }
    }
  });
}

// function setupDatepicker() {
//   if ($('#start_date').prop('type') != 'date') {
//     $('#start_date').datepicker();
//   }

//   if ($('#end_date').prop('type') != 'date') {
//     $('#end_date').datepicker();
//   }
// }

$(document).ready(function () {
  $("#returnLessModal").on("show.bs.modal", function (event) {
    var button = $(event.relatedTarget);
    var loanReturnUrl = button.data("loan-return-url");
    var maxQuantity = button.data("max-quantity");
    var modal = $(this);

    modal.find("#quantity").val(maxQuantity);
    modal.find("form").attr("action", loanReturnUrl);
    modal.find(".modal-footer .btn-primary").click(function () {
      return modal.find("form").submit();
    });
  });

  $("#currentEvent").on("change", function (event) {
    $(".current_event").submit();
  });

  if (typeof calendarDataSource != 'undefined') {
    setup_calendar();
  }

  $('.loan_filtering select').on('change', function (event) {
    $('.loan_filtering').submit();
  });

  $('.loan_filtering #filters_name').on('blur', function (event) {
    $('.loan_filtering').submit();
  })

  setupSearchField();
  // setupDatepicker();
});
