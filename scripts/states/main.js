define(function(require) {
  var Radium = require('core/radium');
  
  var viewObj = Ember.View.create();
  
  var view = Ember.ViewState.create({
    view: viewObj
  });
  
  Radium.MainStateManager = Ember.StateManager.create({
    rootElement: '#feed',
    start: view
  });
  
  return Radium.MainStateManager;
});