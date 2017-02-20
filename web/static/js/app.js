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

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
window.jQuery = window.$ = require("jquery/dist/jquery.min.js");
window.Tether = require("tether/dist/js/tether.min.js");

require("bootstrap/dist/js/bootstrap.js");

$(document).ready(function() {
  $("#returnLessModal").on("show.bs.modal", function(event) {
    console.log("Here");
    var button = $(event.relatedTarget);
    console.log(button);
    var loanId = button.data("loan-id");
    var maxQuantity = button.data("max-quantity");
    console.log(button);
    var modal = $(this);

    modal.find("#quantity").val(maxQuantity);
  });
});
