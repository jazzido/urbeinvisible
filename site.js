$(function() {
  var resetAll = function() {
    $('div.city').animate({ opacity: 1 })
    $("body").css("overflow", "auto");
  };

  $(document).keyup(function(e) {
    if (e.keyCode == 27) { resetAll(); } // ESC
  });

  var smoothScroll = function(sentence, city) {
    $('html, body').animate({
      scrollTop: city.offset().top + (city.height() / 2) - ($(window).height() / 2)
    }, 1000,
                            function() {
                              $('div.city').not(city).animate({ opacity: 0 })
                              sentence.animate({ backgroundColor: '#FFFFC0' });
                              $("body").css("overflow", "hidden"); // disable scrolling
                              window.location.hash = sentence.attr('href');
                            });
  };

  $('.city a[href^="#"]').on('click',function (e) {
    e.preventDefault();

    var target = this.hash,
	$target = $(target);

    $('.city a').css('background-color', '');

    var sentence = $('a' + target);
    var city = sentence.closest('div.city');

    smoothScroll(sentence, city);
  });

  if (window.location.hash !== '') {
    var sentence = $('a' + window.location.hash);
    var city = sentence.closest('div.city');

    smoothScroll(sentence, city);
  }
});
