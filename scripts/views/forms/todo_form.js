define('views/forms/todo_form', function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/forms/todo_form.handlebars');

  Radium.TodoFormView = Ember.View.extend({
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});