Radium.dashboardFeedController = Radium.feedController.create({
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
  // Set up for loading feed
  feedUrl: 'users/%@/feed/'.fmt(Radium.usersController.getPath('loggedInUser.id')),

  addTodo: function() {
    Radium.FormManager.send('showForm', {
      form: 'Todo'
    });
    return false;
  }
});