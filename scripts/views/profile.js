define('views/profile', function(require) {
  
  var view,
      template = require('text!templates/profile.handlebars');
  
  Radium.ProfileView = Ember.View.extend({
    template: Ember.Handlebars.compile(template)
  });
  
});