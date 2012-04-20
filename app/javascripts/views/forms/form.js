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
  }),

  // Helpers
  /**
    @param {String} date A calendar date string formatted as YYYY-MM-DD
    @param {String} time A 24-hr time string in hours and minutes, eg HH-MM
    @return {String} ISO8601 formated date string, or an empty string
  */
  timeFormatter: function(date, time, meridian) {
    if (arguments.length) {
      var dateValues = date.split('-'),
          timeValues = time.split(':'),
          convertedHour = (meridian === 'pm') ? 
                          parseInt(timeValues[0]) + 12 : timeValues[0],
          hour = (convertedHour === 24) ? 00 : convertedHour;

      return Ember.DateTime.create({
        year: dateValues[0],
        month: dateValues[1],
        day: dateValues[2],
        hour: hour,
        minute: timeValues[1]
      }).toISO8601();
    } else {
      var now = Ember.DateTime.create(),
          defaultDate = now.advance({hour: 5});
      return defaultDate.toISO8601();
    }
  }
});