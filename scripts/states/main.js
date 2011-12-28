define(function(require) {
  var Radium = require('core/radium'),
      peopleView = require('views/people').create();
        
  var view = Ember.ViewState.create({
    view: peopleView
  });
  
  Radium.MainStateManager = Ember.StateManager.create({
    rootElement: '#feed',
    start: view
  });
  
  return Radium.MainStateManager;
});