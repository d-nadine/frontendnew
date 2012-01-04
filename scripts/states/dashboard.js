define(function(require) {
  require('views/dashboard');
  
  var state;
  
  state = Ember.ViewState.extend({
    view: Radium.DashboardView.create()
  });
  
  return state;
});
