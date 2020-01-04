$(document).on('turbolinks:load', function() {
  $('#prefecture_key').on("change", function() {
    Rails.fire($(this).parent()[0], "submit");
  });
});