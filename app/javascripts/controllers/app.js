Radium.appController = Ember.Object.create({
  // During development set to true
  isLoggedIn: true,
  // Set to false when all the intial data has been loaded
  isFirstRun: true,
  _routeCache: {},
  currentPage: null,
  selectedForm: null,
  params: null
});