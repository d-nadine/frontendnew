Radium.DealsState = Radium.PageState.extend({
  initialState: 'load',
  view: Radium.DealPageView.create(),
  load: Ember.State.create({
    enter: function() {
      var deals = Radium.store.findAll(Radium.Deal);
      Radium.dealsController.set('content', deals);
    }
  }),
  //Actions
  addResource: function(manager, context) {
    Radium.App.setPath('loggedIn.deals.form.formType', context);
    manager.goToState('form');
  }
});