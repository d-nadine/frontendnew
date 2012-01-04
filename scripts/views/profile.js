define('views/profile', function(require) {
  
  var view,
      template = require('text!templates/profile.handlebars');
  
  view = Ember.View.extend({
    template: Ember.Handlebars.compile(template)
  });
  
  return view;
  
});