define('/views/forms/form', function(require) {
  var Radium = require('radium');

  Radium.FormView = Ember.View.extend({
    submitButton: Ember.Button.extend({
      target: 'parentView',
      action: 'submitForm'
    }),
    cancelFormButton: Ember.Button.extend({
      click: function() {
        Radium.App.goToState('load');
      }
    })
  });

  return Radium;
});