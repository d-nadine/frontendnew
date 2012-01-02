define('views/topbar', function(require) {
  
  require('jquery');
  require('ember');
  
  var view, 
      buttonView = require('views/button'),
      template = require('text!templates/topbar.handlebars');
  
  view = Ember.View.extend({
    currentSectionBinding: 'Radium.appController.currentSection',
    section: function() {
      return (this.get('currentSection') === 'dashboard') ? 'Todo' : 'Contact';
    }.property('currentSection').cacheable(),
    mainActionButton: buttonView,
    template: Ember.Handlebars.compile(template)
  });
  
  return view;
});