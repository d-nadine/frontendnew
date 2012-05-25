Radium.dashboardFeedController = Radium.feedController.create({
  init: function() {
    var pastDates = this.createDateRange(-1, 100),
        futureDates = this.createDateRange(1, 60);

    this.set('futureDates', futureDates);
    this.set('pastDates', pastDates);
  },
  content: [],
  dates: {},
  _pastDateHash: {},
  oldestDateLoaded: null,
  newestDateLoaded: null,
  // Set up for loading feed
  userIdBinding: 'Radium.usersController.loggedInUser.id',
  feedUrl: 'users/%@/feed/',

  addTodo: function() {
    Radium.FormManager.send('showForm', {
      form: 'Todo'
    });
    return false;
  }
});