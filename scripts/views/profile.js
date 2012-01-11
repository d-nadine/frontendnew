define('views/profile', function(require) {
  
  require('ember');
  var Radium = require('radium'),
      view,
      template = require('text!templates/profile.handlebars');
  
  Radium.ProfileView = Ember.View.extend({
    template: Ember.Handlebars.compile(template)
  });
  
  return Radium;
});