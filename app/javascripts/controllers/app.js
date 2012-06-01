Radium.AppController = Ember.Object.extend({
  sideBarView: null,
  feedView: null,
  // During development set to true
  isLoggedIn: true,
  // Store the routes intercepted by Davis
  _statePathCache: {},
  currentPage: null,
  selectedForm: null,
  params: null,
  account: null,

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});
