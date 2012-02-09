define('views/forms/message_form', function(require) {
  var Radium = require('radium'),
    template = require('text!templates/forms/message_form.handlebars');

  Radium.MessageFormView = Radium.FormView.extend({
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});