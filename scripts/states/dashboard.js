define(function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('views/dashboard');
  
  var state;
  
  state = Ember.ViewState.extend({
    view: Radium.DashboardView.create()
  });
  
  return state;
});
