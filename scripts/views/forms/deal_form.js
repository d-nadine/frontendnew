define('views/forms/deal_form', function(require) {
  var Radium = require('radium'),
    template = require('text!templates/forms/deal_form.handlebars');

  Radium.DealFormView = Radium.FormView.extend({
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});