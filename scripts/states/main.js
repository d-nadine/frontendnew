define(function(require) {
  var peopleController = require('controllers/people'),
      peopleView = require('views/people'),
      loader = require('views/jq.progressbar').create(),
      client = require('models/client');
  
  var view = Ember.ViewState.create({
    view: peopleView,
    init: function() {
      Radium.peopleController.createPerson();
      
      this._super();
    }
  });
  
  Radium.App = Ember.StateManager.create({
    rootElement: '#feed',
    start: view
  });
  
  return Radium.App;
});