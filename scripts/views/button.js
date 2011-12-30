define(function(require) {
  require('jquery');
  require('ember');
  
  var button = Ember.Button.extend({
    currentSectionBinding: 'Radium.appController.currentSection',
    section: function() {
      return (this.get('currentSection') === 'dashboard') ? 'Todo' : 'Contact';
    }.property('currentSection').cacheable(),
    classNames: "btn primary".w(),
    isVisible: function() {
      return (this.get('currentSection')) ? YES : NO;
    }.property('currentSection').cacheable(),
    click: function() {
      console.log('click', this.getPath('currentSection'));
    },
    template: Ember.Handlebars.compile('Add {{ section }}')
  });
  
  return button;
});