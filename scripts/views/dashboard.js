define('views/dashboard', function(require) {
  require('views/profile');
  require('views/globalsearch');
  
  var template = require('text!templates/dashboard.handlebars');
      
  Radium.DashboardView = Ember.View.extend({
    template: Ember.Handlebars.compile(template),
    profileView: Radium.ProfileView,
    searchView: Radium.GlobalSearchTextView
  });
  
});