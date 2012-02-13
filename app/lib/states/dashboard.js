Radium.DashboardState = Ember.ViewState.extend({
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
  form: Ember.State.create({
    form: null,
    formType: 'Todo',
    enter: function() {
      var type = this.get('formType');
      console.log('manager', type);
      var form = this.get('form') || Radium[type+'FormView'].create();
      form.appendTo('#form-container');
      this.set('form', form);
      this.setPath('parentState.isFormAddView', true);
    },
    exit: function() {
      this.get('form').destroy();
      this.set('form', null);
      this.setPath('parentState.isFormAddView', false);
    }
  }),

  //Actions
  loadForm: function(manager, context) {
    Radium.App.setPath('loggedIn.dashboard.form.formType', context);
    manager.goToState('form');
  }
});
