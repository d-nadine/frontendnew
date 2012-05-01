Radium.FormView = Ember.View.extend({
  // tagName: 'form',
  classNames: ['well'],

  // Validation properties
  hasNoOptions: true,
  isSubmitting: false,
  isValid: false,
  isMatchError: null,

  // Actions and basic states. Send notifications and control the submi
  didInsertElement: function() {
    this.$('.more-options').addClass('hide');
    this.$('fieldset:first').find('input:text, textarea').focus();
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
    $flashMessage.delay(2000).fadeOut(function() {
      $(this).remove();
    });
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
      Radium.FormManager.send('closeForm');
    });
  },

  submit: function(event) {
    event.preventDefault();
    this.submitForm();
    return false;
  },

  // Show/hide the extra options when creating a todo.
  toggleOptions: function() {
    this.toggleProperty('hasNoOptions');
    return false;
  },

  toggleOptionsText: function() {
    return (this.get('hasNoOptions')) ? 'More options' : 'Less options';
  }.property('hasNoOptions').cacheable(),

  moreOptions: Ember.View.extend({
    isVisibleBinding: 'parentView.hasMoreOptions'
  }),

  submitButton: Ember.Button.extend({
    _buttonTextCache: null,
    // target: 'parentView',
    // action: 'submitForm',
    attributeBindings: ['type'],
    type: 'submit',
    isSubmittingBinding: 'parentView.isSubmitting',
    classNameBindings: ['isSubmitting'],
    isValid: 'parentView.isValid',
    template: Ember.Handlebars.compile('<i class="icon-inline-loading"></i> <span>Create Todo</span>'),
    disabled: function() {
      var isSubmitting = this.getPath('parentView.isSubmitting'),
          isValid = this.getPath('parentView.isValid');
      return (isSubmitting || !isValid) ? true : false;
    }.property('parentView.isSubmitting', 'parentView.isValid').cacheable(),
    changeTextOnSubmit: function() {
      var cachedText = this.get('_buttonTextCache');
      if (this.get('isSubmitting') === true) {
        this.$('span').text('Sending...');
      } else {
        this.$('span').text(cachedText);
      }
    }.observes('isSubmitting'),
    // On init grab and cache the button's text from the Handlebars
    // template so that it can be reverted back if the form returns
    // an error after being disabled and reset as "Sending..."
    didInsertElement: function() {
      var text = this.$('span').text();
      this.set('_buttonTextCache', text);
    }
  }),
  cancelFormButton: Ember.Button.extend({
    target: 'parentView',
    action: 'close',
    disabledBinding: 'parentView.isSubmitting'
  })
});