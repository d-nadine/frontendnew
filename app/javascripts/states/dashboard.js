Radium.DashboardPage = Ember.State.extend({
  enter: function(manager) {
    Radium.get('appController').set('sideBarView', Ember.View.create({
      templateName: 'dash-sidebar'
    }));
    
    // var user = Radium.usersController.get('loggedInUser'),
    //     userId = user.get('id'),
    //     dashboardFeedController = Radium.feedController.create({
    //     init: function() {
    //       var pastDates = this.createDateRange({limit: 100}),
    //           futureDates = this.createDateRange({limit: 60, direction: 1});

    //       this.set('futureDates', futureDates);
    //       this.set('pastDates', pastDates);
    //     },
    //     content: [],
    //     _pastDateHash: {},
    //     oldestDateLoaded: null,
    //     newestDateLoaded: null,
    //     oldestHistoricalDate: user.get('createdAt'),
    //     // Set up for loading feed
    //     feedUrl: 'users/%@/feed/'.fmt(userId),

    //     addTodo: function() {
    //       Radium.get('formManager').send('showForm', {
    //         form: 'Todo'
    //       });
    //       return false;
    //     }
    //   });

    // this.set('view', Radium.DashboardView.create({
    //   controller: dashboardFeedController
    // }));

    this._super(manager);
  },

  index: Ember.State.create({
    enter: function(manager) {
      Radium.set('activityFeedController', Radium.ActivityFeedController.create());
      Radium.get('appController').set('feedView', Radium.HistoricalFeedView.create({
        contentBinding: 'Radium.activityFeedController'
      }));
    }
  })
});
