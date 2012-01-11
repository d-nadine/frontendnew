define(function(require) {
  require('ember');
  var Radium = require('radium');
  
  Radium.appController = Ember.Object.create({
    currentSection: null
  });
  
  return Radium;
});