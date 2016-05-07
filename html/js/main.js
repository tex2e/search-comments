'use strict';

var hoge = 123;
var comments = [];

var getDatabase = jQuery.get("database/c")
  .done(function (data) {
    comments = data.split("\n");
  })
  .fail(function () {
    //
  });

$.when(getDatabase, $(document))
  .done(function () {
    // append table
    $("#js-comment-table").append("<table></table>");
    var table = $("#js-comment-table table");
    // append rows
    var tablize = function (e) {
      return "<tr><td>" + e + "</td></tr>";
    };
    table.html(comments.map(tablize).join("<br />"));
  });

$(document).ready(function () {
  $("#js-search-bar input[name=search-bar]").on('input', function (e) {
    var inputText = e.target.value;
    var table = $("#js-comment-table table");
    table.find("tr")
      .filter(function (index) {
        return $(this).text().indexOf(inputText) === -1;
      })
      .hide();
  });
});
