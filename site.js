$(function() {

  var resetAll = function() {
    $('div.city').animate({ opacity: 1 })
    $("body").css("overflow", "auto");
    $('body').removeClass('focused');
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
                              $("body")
                              .css("overflow", "hidden") // disable scrolling
                              .addClass('focused');

                              window.location.hash = sentence.attr('href').substring(0, sentence.attr('href').length - 1);
                            });
  };

  $('.city a[href^="#"]').on('click',function (e) {
    if ($('body').hasClass('focused')) return;

    e.preventDefault();

    var target = this.hash;

    console.log(target);

    $('.city a').css('background-color', '');
    var sentence = $('a' + target);
    var city = sentence.closest('div.city');

    smoothScroll(sentence, city);
  });

  $('body').click(function(e) {
    if ($(this).hasClass('focused')) {
      e.preventDefault(); e.stopPropagation();
      resetAll();
    }
  });

  if (window.location.hash !== '') {
    var sentence = $('a' + window.location.hash + '_');
    var city = sentence.closest('div.city');

    smoothScroll(sentence, city);
  }
});
