$(document).ready(function() {
  $('a.audio').click(function(e) {
    l = $(this);
    if ($('audio', l.parent()).length == 0)
      $('<audio src="'+l.attr('href')+'"></audio>').insertAfter(l);
    l.parent().find('audio').trigger('play');
    e.preventDefault();
  });
});
