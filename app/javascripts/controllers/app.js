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
  
  bootstrap: function(data){
    Radium.store.load(Radium.Account, data.account);
    var account = Radium.store.find(Radium.Account, data.account.id),
        clusters = [];
    // TODO: Do we still need to do this 
    // Have to strip out any items tagged 'scheduled_for'
    // data.feed.forEach(function(activity) {
    //   if (activity.tag !== 'scheduled_for') {
    //     feedItems.push(activity);
    //   }
    // });

    Radium.store.loadMany(Radium.Activity, data.feed.activities);


    data.feed.clusters.forEach(function(cluster){
      var emCluster = Ember.Object.create({});
      emCluster.setProperties(cluster);
      clusters.push(emCluster);
    });

    //kick off observers
    this.set('account', account);
    this.set('users', data.users);
    this.set('current_user', data.current_user);
    this.set('overdue_feed', data.overdue_activities);
    this.set('clusters', clusters);
    this.set('contacts', data.contacts);

    Radium.get('activityFeedController').bootstrapLoaded();
  },

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});
