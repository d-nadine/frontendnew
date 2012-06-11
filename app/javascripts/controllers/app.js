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
  createDataStoreWorker: function(bootstrap){
    var feed = bootstrap.current_user.meta.feed;
    //TODO: Do we need to include the timezone?
    var start_date = Ember.DateTime.parse(feed.start_date, '%Y-%m-%d'),
        end_date = Ember.DateTime.parse(feed.end_date, '%Y-%m-%d'),
        diffDays = Ember.DateTime.DifferenceInDays(start_date, end_date),
        date_ranges = Ember.A(),
        days_to_advance = -1,
        interval = 1;

    if(diffDays <= interval){
      date_ranges.pushObject({start: start_date.toFormattedString('%Y-%m-%d'), end: end_date.toFormattedString('%Y-%m-%d')});
      diffDays = 0; 
    }

    while(diffDays > 0){
      date_ranges.pushObject({start: start_date.advance({day: days_to_advance}).toFormattedString('%Y-%m-%d'), end: start_date.advance({day: (days_to_advance + interval) }).toFormattedString('%Y-%m-%d')});

      days_to_advance += interval + 1;
      diffDays -= interval;

      if(diffDays < interval){
        date_ranges.pushObject({start: start_date.advance({day: days_to_advance}).toFormattedString('%Y-%m-%d'), end: start_date.advance({day: (days_to_advance + diffDays)}).toFormattedString('%Y-%m-%d')});
        break;
      }
    }

    var urls = date_ranges.map(function(dateRange){
      return '/api/users/%@/feed?start_date=%@&end_date=%@'.fmt(bootstrap.current_user.id, dateRange.start, dateRange.end);
    });

    urls.forEach(function(url){    
      var request = jQuery.extend({url: url}, CONFIG.ajax);
      $.when($.ajax(request)).then(function(data){
        if(data.feed.activities.length > 0){
          Radium.store.loadMany(Radium.Activity, data.feed.activities);
        }
      });
    });
  },
  bootstrap: function(data){
    this.createDataStoreWorker(data);

    Radium.store.load(Radium.Account, data.account);
    var account = Radium.store.find(Radium.Account, data.account.id),
        clusters = [];

    //kick off observers
    this.set('account', account);
    this.set('users', data.users);
    this.set('current_user', data.current_user);
    this.set('overdue_feed', data.overdue_activities);
    this.set('clusters', data.feed.clusters.map(function(data) { return Ember.Object.create(data); }));
    this.set('contacts', data.contacts);

    Radium.get('activityFeedController').bootstrapLoaded();
  },

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});
