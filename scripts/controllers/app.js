define(function(require) {
  require('ember');
  require('radium');
  
  Radium.appController = Ember.Object.create({
    currentSection: null
  });
});