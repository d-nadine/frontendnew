define('views/forms/discussion_form', function(require) {
  var Radium = require('radium'),
    template = require('text!templates/forms/discussion_form.handlebars');

  Radium.DiscussionFormView = Radium.FormView.extend({
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});