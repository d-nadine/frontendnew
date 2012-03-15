Radium.LoadingView = Ember.View.extend({
  elementId: 'loading-modal',
  classNames: 'modal'.w(),
  template: Ember.Handlebars.compile('<div class="modal-body"><div class="progress progress-info progress-striped active"><div class="bar" style="width: 100%;"></div></div></div>'),
  didInsertElement: function() {
    $('body').append($('<div class="modal-backdrop fade in"/>'));
  },
  willDestroyElement: function() {
    $('.modal-backdrop').fadeOut('fast', function() {
      $(this).remove();
    });
  }
});