Radium.DashboardState = Radium.PageState.extend({
    
  view: Radium.DashboardView,

  isFormAddView: false,

  start: Ember.State.create({
    enter: function(manager) {
      var user = Radium.usersController.get('loggedInUser');
      Radium.store.adapter.set('selectedUserID', user.get('id'));
      var activities = Radium.store.find(Radium.Activity, {
        type: 'user',
        id: user.get('id')
      });

      activities.addObserver('isLoaded', function() {
        Radium.dashboardController.set('selectedUser', user);
        Radium.activitiesController.set('content', activities);
        manager.goToState('ready');
      });
    }
  }),

  ready: Ember.State.create({}),

  feed: Ember.State.create({
    enter: function(manager) {
      
    },
    exit: function() {
      
    }
  }),

  specificDate: Ember.State.create({
    enter: function(manager) {
      
    },
    exit: function() {
      Radium.selectedFeedDateController.set('content', []);
    }
  }),

  /**
    ACTIONS
    ------------------------------------
  */
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
  },

  selectDate: function(manager, context) {
    var activity = Radium.Activity.filter(function(data) {
      var date = data.get('updated_at').replace(/T(.*)/g, '');
      if (date === context) {
        return true;
      } else {
        return false;
      }
    });
    Radium.activitiesController.set('dateFilter', context);
    Radium.selectedFeedDateController.set('content', activity);
    var ids = Radium.selectedFeedDateController.get('todos');
    var todos = Radium.store.findMany(Radium.Todo, ids);

    manager.goToState('specificDate');

  }
});
