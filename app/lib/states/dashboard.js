Radium.DashboardState = Radium.PageState.extend({
  initialState: 'load',
  view: Radium.DashboardView.create(),
  isFormAddView: false,
  load: Ember.State.create({
    enter: function() {
      
    }
  }),
  //Actions
  loadForm: function(manager, context) {
    Radium.App.setPath('loggedIn.dashboard.form.formType', context);
    manager.goToState('form');
  }
});
