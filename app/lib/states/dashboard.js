Radium.DashboardState = Radium.PageState.extend({
  
  initialState: 'ready',
  
  view: Radium.DashboardView,
  
  isFormAddView: false,

  loading: Ember.ViewState.create({
    view: Radium.LoadingView
  }),

  ready: Ember.State.create({
    enter: function() {
      console.log('Ready');
      var user = Radium.usersController.get('loggedInUser');
      Radium.store.adapter.set('selectedUserID', user.get('id'));
      var activities = Radium.store.find(Radium.Activity, {
        type: 'user',
        id: user.get('id')
      });
      Radium.dashboardController.set('selectedUser', user);
      Radium.activitiesController.set('content', activities);
    }
  }),

  specificDate: Ember.State.create({
    exit: function() {
      Radium.activitiesController.set('content', Radium.store.findAll(Radium.Activity));
    } 
  }),
  //Actions
  addResource: function(manager, context) {
    Radium.App.setPath('loggedIn.dashboard.form.formType', context);
    manager.goToState('form');
  },
  loadFeed: function(manager, context) {
    var activity = Radium.store.find(Radium.Activity, context);
    manager.goToState('loading');
    activity.addObserver('isLoaded', function() {
      Radium.activitiesController.set('content', activity);
      manager.goToState('ready');
    });
  }
});
