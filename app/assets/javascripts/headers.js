jQuery(document).on('turbolinks:load', function(){
  const hum = $('#hamburger, .close')
  const nav = $('.sp-nav')
  hum.on('click', function(){
     nav.toggleClass('toggle');
     hum.toggleClass('hum_toggle');
  });
});