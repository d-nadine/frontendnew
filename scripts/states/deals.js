define('states/deals', function(require) {
  
  var Radium = require('radium');
  
  Radium.DealsState = Ember.ViewState.extend({
    view: Radium.DealPageView.create()
  });
  
  return Radium;
});
