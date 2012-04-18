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

  today: function() {
    return Ember.DateTime.create();
  }.property().cacheable()
});