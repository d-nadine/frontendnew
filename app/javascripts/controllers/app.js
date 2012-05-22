Radium.appController = Ember.Object.create({
  // During development set to true
  isLoggedIn: true,
  // Set to false when all the intial data has been loaded
  isFirstRun: true,
  // Store the routes intercepted by Davis
  _statePathCache: {},
  currentPage: null,
  selectedForm: null,
  params: null,

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});