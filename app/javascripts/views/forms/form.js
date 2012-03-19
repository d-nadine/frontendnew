Radium.FormView = Ember.View.extend({
  isSubmitting: false,
  // Actions and basic states
  didInsertElement: function() {
    this.$().hide().slideDown('slow');
  },
  sending: function() {
    this.set('isSubmitting', true);
    this.$('input, select, textarea').prop('disabled', true);
  },
  flash: function(type, message) {
    var $flashMessage = $('<div class="alert"/>')
                        .addClass('alert-' + type)
                        .text(message);
    this.$().before($flashMessage);
    setTimeout(function() {
      $flashMessage.fadeOut(function() {
        $(this).remove();
      });
    }, 2000);
  },
  success: function(message) {
    this.flash('success', message);
    this.set('isSubmitting', false);
    this.close();
  },
  error: function(message) {
    this.flash('error', message);
    this.$('input, select, textarea').prop('disabled', false);
    this.set('isSubmitting', false);
  },
  close: function() {
    this.$().slideUp('fast', function() {
      Radium.App.send('closeForm');
    });
  },
  submitButton: Ember.Button.extend({
    _buttonTextCache: null,
    target: 'parentView',
    action: 'submitForm',
    isSubmittingBinding: 'parentView.isSubmitting',
    disabledBinding: 'isSubmitting',
    changeTextOnSubmit: function() {
      var cachedText = this.get('_buttonTextCache');
      if (this.get('isSubmitting') === true) {
        this.$().text('Sending...');
      } else {
        this.$().text(cachedText);
      }
    }.observes('disabled'),
    // On init grab and cache the button's text from the Handlebars
    // template so that it can be reverted back if the form returns
    // an error after being disabled and reset as "Sending..."
    didInsertElement: function() {
      var text = this.$().text();
      this.set('_buttonTextCache', text);
    }
  }),
  cancelFormButton: Ember.Button.extend({
    target: 'parentView',
    action: 'close',
    disabledBinding: 'parentView.isSubmitting'
  })
});