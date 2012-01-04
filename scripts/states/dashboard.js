define(function(require) {
  
  var state, viewz, DashboardView = require('views/dashboard').create();
  
  state = Ember.ViewState.create({
    view: DashboardView,
    enter: function() {
      DashboardView.appendTo('#main');
    },
    exit: function() {
      DashboardView.remove();
    }
  });
  
  return state;
});
