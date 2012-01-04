define('views/dashboard', function(require) {
  
  var template = require('text!templates/dashboard.handlebars');
  Radium.DashboardView = Ember.View.extend({
    template: Ember.Handlebars.compile(template)
  });
  
});