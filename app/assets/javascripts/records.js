document.addEventListener('turbolinks:load', function(){
  $('#prefecture_key').change(function() {
    $(this).parent().submit();
  });
});