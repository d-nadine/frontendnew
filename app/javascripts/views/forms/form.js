Radium.FormView = Ember.View.extend({
  tagName: 'form',
  classNames: 'well form-horizontal radium-form'.w(),
  layoutName: 'form_layout',

  // Validation properties
  hasNoOptions: true,
  isSubmitting: false,
  isValid: false,
  isMatchError: null,
  invalidFields: Ember.A([]),

  keyUp: function(event) {
    if (event.keyCode === 27) {
      this.close();
    }
  },

  // Actions and basic states. Send notifications and control the submi
  didInsertElement: function() {
    this.$('.more-options').addClass('hide');
    this.$('fieldset:first').find('input:text, textarea').focus();
  },

  willDestroy: function() {
    this.get('invalidFields').clear();
  },

  sending: function() {
    this.set('isSubmitting', true);
    this.$('input, select, textarea').prop('disabled', true);
  },
  
  flash: function(type, message) {
    var self = this,
        $flashMessage = $('<div class="alert"/>')
                        .addClass('alert-' + type)
                        .text(message);
    this.$().before($flashMessage);
    $flashMessage.delay(2000).fadeOut(function() {
      $(this).remove();

      if (type === 'success') {
        self.close();
      }
    });
  },
  success: function(message) {
    var self = this;
    // self.flash('success', message);
    self.set('isSubmitting', false);
    this.$().slideUp('fast', function() {
      self.close();
    });
  },
  error: function(message) {
    this.flash('error', message);
    this.$('input, select, textarea').prop('disabled', false);
    this.set('isSubmitting', false);
  },

  fail: function() {
    this.$('input, select, textarea').prop('disabled', false);
    this.set('isSubmitting', false);
  },

  hide: function() {
    this.$().hide();
  },

  show: function() {
    this.$().show();
  },

  close: function(event) {
    var container = this.get('parentView');
    this.$().slideUp('fast', function() {
      container.close();
    });
    return false;
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

  submitButton: Ember.View.extend(Ember.TargetActionSupport, {
    tagName: 'button',
    _buttonTextCache: null,
    // target: 'parentView',
    // action: 'submitForm',
    attributeBindings: ['type', 'disabled'],
    type: 'submit',
    isSubmittingBinding: 'parentView.isSubmitting',
    classNameBindings: ['isSubmitting'],
    isValidBinding: 'parentView.isValid',
    template: Ember.Handlebars.compile('<i class="icon-inline-loading"></i> <span>Save</span>'),
    disabled: function() {
      var isSubmitting = this.getPath('parentView.isSubmitting'),
          isValid = this.get('isValid');
      return (isSubmitting || !isValid) ? true : false;
    }.property('parentView.isSubmitting', 'isValid').cacheable(),
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

  cancelFormButton: Ember.View.extend(Ember.TargetActionSupport, {
    tagName: 'a',
    attributeBindings: ['href', 'title'],
    href: '#',
    title: 'Close form',
    target: 'parentView',
    action: 'close'
  }),

  checkForEmpty: function(hash) {
    for (var val in hash) {
      if (hash.hasOwnProperty(val)) {
        return hash[val] === null || hash[val] === undefined;
      }
    }
  }
});
