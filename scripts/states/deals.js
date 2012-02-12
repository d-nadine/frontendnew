define('states/deals', function(require) {
  
  var Radium = require('radium');
  
  Radium.DealsState = Ember.ViewState.extend({
    initialState: 'load',
    view: Radium.DealPageView.create(),
    load: Ember.State.create({
      enter: function() {
        // var deals = Radium.store.findAll(Radium.Deal);
        // Radium.dealsController.set('content', deals);
      }
    })
  });
  
  return Radium;
});
