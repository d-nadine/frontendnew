Radium.DashboardPage = Ember.ViewState.extend({
    
  view: null,

  enter: function(manager) {
    var user = Radium.usersController.get('loggedInUser'),
        userId = user.get('id'),
        dashboardFeedController = Radium.feedController.create({
        init: function() {
          var pastDates = this.createDateRange({limit: 100}),
              futureDates = this.createDateRange({limit: 60, direction: 1});

          this.set('futureDates', futureDates);
          this.set('pastDates', pastDates);
        },
        content: [],
        _pastDateHash: {},
        oldestDateLoaded: null,
        newestDateLoaded: null,
        oldestHistoricalDate: user.get('createdAt'),
        // Set up for loading feed
        feedUrl: 'users/%@/feed/'.fmt(userId),

        addTodo: function() {
          Radium.FormManager.send('showForm', {
            form: 'Todo'
          });
          return false;
        }
      });

    this.set('view', Radium.DashboardView.create({
      controller: dashboardFeedController
    }));

    this._super(manager);
  },

  index: Ember.State.create({
    firstRun: true,
    enter: function(manager) {
      // Crossfilter feed, disabled until charts are integrated
      // Radium.dashboardFeedListController.registerFeeds([
      //   Radium.feedByKindController,
      //   Radium.feedByUserController,
      //   Radium.feedByContactController,
      //   Radium.feedByDateController,
      //   Radium.feedByActivityController
      // ]);

    }
  }),

  ready: Ember.State.create({}),

  /**
    ACTIONS
    ------------------------------------
  */

});
