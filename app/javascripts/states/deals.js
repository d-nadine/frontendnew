Radium.DealsPage = Ember.ViewState.extend({
  initialState: 'load',
  view: Radium.DealPageView.create(),
  load: Ember.State.create({
    enter: function() {
      var deals = Radium.store.find(Radium.Deal, {page: 1});
      Radium.dealsController.set('content', deals);
    }
  }),
  
  //Actions
});