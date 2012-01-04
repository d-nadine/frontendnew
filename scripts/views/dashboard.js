define('views/dashboard', function(require) {
  
  var view, template = require('text!templates/dashboard.handlebars');
  
  view = Ember.View.extend({
    template: Ember.Handlebars.compile(template)
  })
  
  return view;
  
});