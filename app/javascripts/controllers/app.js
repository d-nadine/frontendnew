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
  timezone: new Date().getTimezoneOffset(),
  formContainerView: null,
  bootstrap: function(data){
    data.feed.activities.forEach(function(activity){
      Radium.store.load(Radium.Activity, activity);
    });

    Radium.Utils.pluckReferences(data.feed.activities);

    Radium.store.load(Radium.Account, data.account);
    var account = Radium.store.find(Radium.Account, data.account.id),
        clusters = [];

    Radium.store.loadMany(Radium.Notification, data.notifications);
    var notifications = Radium.store.findMany(Radium.Notification, data.notifications.mapProperty('id').uniq());

    //kick off observers
    this.set('account', account);
    this.set('users', data.users);
    this.set('current_user', data.current_user);
    this.set('overdue_feed', data.overdue_activities);
    this.set('scheduled_feed', data.feed.scheduled_activities);
    this.set('clusters', data.feed.clusters.map(function(data) { return Ember.Object.create(data); }));
    this.set('contacts', data.contacts);
    this.set('feed', data.feed);
    // Can set a mutable controller with findMany, I'm afraid
    this.set('notifications', notifications.map(function(item) {return item;}));
  },

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});
