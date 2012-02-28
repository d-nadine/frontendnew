Radium.DashboardState = Radium.PageState.extend({
  
  initialState: 'ready',
  
  view: Radium.DashboardView,
  
  isFormAddView: false,

  loading: Ember.ViewState.create({
    view: Radium.LoadingView
  }),

  ready: Ember.State.create({
    enter: function(manager, transition) {
      console.log('Ready');
      var user = Radium.usersController.get('loggedInUser');
      Radium.store.adapter.set('selectedUserID', user.get('id'));
      var activities = Radium.store.find(Radium.Activity, {
        type: 'user',
        id: user.get('id')
      });

      activities.addObserver('isLoaded', function() {
        Radium.dashboardController.set('selectedUser', user);
        Radium.activitiesController.set('content', activities);
        manager.goToState('feed');
      });
    }
  }),

  feed: Ember.ViewState.create({
    view: Ember.View.extend({
      templateName: 'feed_date_group'
    }),
    enter: function(manager) {
      var view = this.get('view').create();
      view.appendTo($('#feed'));
    },
    exit: function() {
      var view = this.get('view');
      view.remove();
    }
  }),

  specificDate: Ember.ViewState.create({
    view: Ember.View.extend({
      templateName: 'feed_date'
    }),
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
      manager.goToState('feed');
    });
  },

  selectDate: function(manager, context) {
    Radium.activitiesController.set('dateFilter', context);
    manager.goToState('specificDate');
  }
});
