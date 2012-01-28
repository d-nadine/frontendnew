define(function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('views/dashboard');

  var state;
  
  state = Ember.ViewState.extend({
    initialState: 'load',
    view: Radium.DashboardView.create(),
    load: Ember.State.create({
      enter: function() {
        var activities = Radium.store.findAll(Radium.Activity);
        Radium.feedController.set('content', activities);
      }
    })
  });
  
  return state;
});
