Radium.FormView = Ember.View.extend({
  /**
    Default submit form action.
  */

  didInsertElement: function() {
    this._super();
    this.$().hide().slideDown('slow');
  },
  submitForm: function() {
    this.$().slideUp('fast', function() {
      Radium.App.send('closeForm');
    });
  },
  hideForm: function() {
    this.$().slideUp('fast', function() {
      Radium.App.send('closeForm');
    });
  },
  submitButton: Ember.Button.extend({
    target: 'parentView',
    action: 'submitForm'
  }),
  cancelFormButton: Ember.Button.extend({
    target: 'parentView',
    action: 'hideForm'
  })
});