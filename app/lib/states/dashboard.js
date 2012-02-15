Radium.DashboardState = Radium.PageState.extend({
  initialState: 'load',
  view: Radium.DashboardView.create(),
  isFormAddView: false,
  load: Ember.State.create({
    enter: function() {
      var activities = Radium.store.findAll(Radium.Activity);
      Radium.dashboardController.set('content', activities);

      var announcements = Radium.store.findAll(Radium.Announcement);
      Radium.announcementsController.set('content', announcements);
    }
  }),
  //Actions
  loadForm: function(manager, context) {
    Radium.App.setPath('loggedIn.dashboard.form.formType', context);
    manager.goToState('form');
  }
});
