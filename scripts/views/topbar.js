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
    highlightNav: function() {
      var section = this.get('currentSection');
      $('ul#main-nav').find('li')
        .removeClass('active')
        .filter('li#btn-' + section).addClass('active');
    }.observes('currentSection'),
    didInsertElement: function() {
      var section = this.get('currentSection');
      $('li#btn-'+section).addClass('active');
    },
    mainActionButton: buttonView,
    template: Ember.Handlebars.compile(template)
  });
  
  return view;
});