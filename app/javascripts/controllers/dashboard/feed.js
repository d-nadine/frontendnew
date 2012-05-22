Radium.dashboardFeedController = Radium.feedController.create({
  content: [],
  dates: {},
  oldestDateLoaded: null,
  newestDateLoaded: null,

  addTodo: function() {
    Radium.FormManager.send('showForm', {
      form: 'Todo'
    });
    return false;
  }
});