Radium.LoadingView = Ember.View.extend({
  elementId: 'loading',
  classNames: 'progress progress-info progress-striped active'.w(),
  template: Ember.Handlebars.compile('<div class="bar" style="width: 100%;"></div>'),
  didInsertElement: function() {
    $('body').append($('<div id="cover" class="modal-backdrop fade in"/>'));
  },
  willDestroyElement: function() {
    $('#cover').fadeOut('fast', function() {
      $(this).remove();
    });
  }
});