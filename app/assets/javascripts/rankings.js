$(document).on('turbolinks:load', function() {
  $('#month').on("change", function() {
    Rails.fire($(this).parent()[0], "submit");
  });
});