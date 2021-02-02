$(document).on('turbolinks:load', function() {
  jQuery(function ($) {
    term_val = $("#term").val();
    $(`#${term_val}`).addClass("active");
  });
});