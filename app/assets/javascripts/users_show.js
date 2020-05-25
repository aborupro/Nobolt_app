jQuery(function ($) {
  $('.table-title').on('click', function () {
    /*クリックでコンテンツを開閉*/
    $(".hidden_row").slideToggle(200);
    /*矢印の向きを変更*/
    $(".record-num").toggleClass('open');
  });

  });