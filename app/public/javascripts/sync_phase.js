$(function() {
  if ($('*[data-flippd-phase]').length) {
    var phase = $('*[data-flippd-phase]').data('flippd-phase');
    console.log(phase);
    var currentPhaseNavLink = $('#navbar li:nth-child(' + phase + ')');
    currentPhaseNavLink.addClass('active');
  }
});
