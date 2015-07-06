$(function() {
  if ($('#video').length) {
    var phase = $('#video').data('flippd-phase');
    var currentPhaseNavLink = $('#navbar li:nth-child(' + phase + ')');
    console.log(currentPhaseNavLink);
    currentPhaseNavLink.addClass('active');
  }
});
