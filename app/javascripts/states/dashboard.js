Radium.DashboardPage = Ember.ViewState.extend(Radium.PageStateMixin, {
    
  view: Radium.DashboardView,

  isFormAddView: false,

  index: Ember.State.create({
    firstRun: true,
    loadActivities: function(manager) {
      // DISABLE FOR NOW UNTIL NEW FEEDS FEED IS READY
      // var self = this;
      // var user = Radium.usersController.get('loggedInUser');
      // Radium.store.adapter.set('selectedUserID', user.get('id'));
      // var activities = Radium.store.find(Radium.Activity, {
      //   type: 'user',
      //   id: user.get('id')
      // });

      // activities.addObserver('isLoaded', function() {
      //   console.log('activities loaded');
      //   // Radium.dashboardController.set('selectedUser', user);
      //   // Radium.activitiesController.set('content', activities);
      //   Radium.selectedUserFeedController.set('selectedUser', user);
      //   manager.goToState('ready');
      //   self.set('firstRun', false);
      // });
      Ember.run.next(function() {
        manager.goToState('ready');
      });
    },
    enter: function(manager) {
      var firstRun = this.get('firstRun');
      if (firstRun) {
        this.loadActivities(manager);
      } else {
        manager.goToState('ready');
      }
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
  loadFeed: function(manager, context) {
    // Hack. Need to let the adapter know which user is requesting a feed
    // so the url `/users/:id/feed` can be loaded.
    Radium.store.adapter.set('selectedUserID', context.data.id);
    var activity = Radium.store.find(Radium.Activity, context.data);
    Radium.selectedUserFeedController.set('content', []);
    manager.goToState('loading');
    activity.addObserver('isLoaded', function() {
      Radium.selectedUserFeedController.set('selectedUser', context.user);
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
