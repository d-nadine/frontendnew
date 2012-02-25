Radium.DashboardState = Radium.PageState.extend({
  
  initialState: 'loading',
  
  view: Radium.DashboardView.create(),
  
  isFormAddView: false,

  loading: Ember.State.create({
    enter: function() {
      console.log('loading');
      // Fetch data
      // var activities = Radium.store.find(Radium.Activity, {
      //   type: 'user',
      //   id: Radium.usersController.getPath('loggedInUser.id')
      // });
      // Radium.activitiesController.set('content', activities);
    }
  }),
  ready: Ember.State.create({}),
  specificDate: Ember.State.create({
    exit: function() {
      Radium.activitiesController.set('content', Radium.store.findAll(Radium.Activity));
    } 
  }),
  //Actions
  loadForm: function(manager, context) {
    Radium.App.setPath('loggedIn.dashboard.form.formType', context);
    manager.goToState('form');
  },
  loadFeed: function(manager, context) {
    debugger;
    var activity = Radium.store.find(Radium.Activity, context);
    manager.goToState('loggedIn.dashboard.loading');
    activity.addObserver('isLoaded', function() {
      Radium.activitiesController.set('content', activity);
      manager.goToState('loggedIn.dashboard.ready');
    });
  }
});
