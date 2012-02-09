define('views/forms/meeting_form', function(require) {
  var Radium = require('radium'),
      template = require('text!templates/forms/meeting_form.handlebars');

  Radium.MeetingFormView = Radium.FormView.extend({
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});