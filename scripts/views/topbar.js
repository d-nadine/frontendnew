define('views/topbar', function(require) {
  
  require('ember');
  var Radium = require('radium'),
      buttonView = require('views/button'),
      template = require('text!templates/topbar.handlebars');
  
  Radium.TopbarView = Ember.View.extend({
    currentSectionBinding: 'Radium.appController.currentSection',
    section: function() {
      var section = this.get('currentSection') || 'dashboard';
      return (section === 'dashboard') ? 'Todo' : 'Contact';
    }.property('currentSection').cacheable(),
    highlightNav: function() {
      var section = this.get('currentSection') || 'dashboard';
      $('ul#main-nav').find('li')
        .removeClass('active')
        .filter('li#btn-' + section).addClass('active');
    }.observes('currentSection'),
    didInsertElement: function() {
      var section = this.get('currentSection') || 'dashboard';
      if (section) $('li#btn-'+section).addClass('active');
    },
    mainActionButton: buttonView,
    template: Ember.Handlebars.compile(template)
  });
  
  return Radium;
});