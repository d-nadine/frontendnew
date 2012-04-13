Radium.MiniLoader = Ember.State.extend({
  miniLoader: $('<div id="mini-loader" class="alert alert-block"><h4 class="alert-heading">Loading &hellip;</h4></div>').hide(),
  enter: function() {
    this.get('miniLoader').appendTo($('body')).fadeIn();
  },
  exit: function() {
    $('#mini-loader').fadeOut(function() {
      $(this).remove();
    });
  }
});