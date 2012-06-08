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
    //TODO: initialise from real dates
    // var start_date = Ember.DateTime.create(new Date(Date.parse(feed.start_date)));
    // var end_date = Ember.DateTime.create(new Date(Date.parse(feed.end_date)));

    var start_date = Ember.DateTime.create().advance({day: -28}),
        end_date = Ember.DateTime.create(),
        diff = Ember.DateTime.compareDate(end_date, start_date),
        date_ranges = Ember.A(),
        interval = 7;

    if(diff <= 7){
      date_ranges.pushObject({start: start_date.toFormattedString('%Y-%m-%d'), end: end_date.toFormattedString('%Y-%m-%d')});
      diff = 0; 
    }

    while(diff > 0){
      date_ranges.pushObject({start: start_date.toFormattedString('%Y-%m-%d'), end: start_date.advance({day: interval}).toFormattedString('%Y-%m-%d')});

      diff -= interval;

      star_date = start_date.advance({day: interval});

      if(diff < interval){
        date_ranges.pushObject({start: start_date.toFormattedString('%Y-%m-%d'), end: start_date.advance({day: diff}).toFormattedString('%Y-%m-%d')});
        break;
      }
    }

    var urls = date_ranges.map(function(dateRange){
      return '/api/users/%@/feed?start_date=%@&end_date=%@'.fmt(bootstrap.current_user.id, dateRange.start, dateRange.end);
    }); 

    var worker = new Worker('worker.js');

    worker.addEventListener('message', function(e){
      var activities = JSON.parse(e.data).feed.activities;
      Radium.store.loadMany(Radium.Activity, e.data);
      worker.terminate();
    });

    worker.addEventListener('error', function(e){
      worker.terminate();
    });

    worker.postMessage({
      key: CONFIG.api,
      urls:  urls
    });
  },
  bootstrap: function(data){
    if(Radium.Utils.browserSupportsWebWorkers()){
      this.createDataStoreWorker(data);
    }else{  
      //TODO: What to do or can we rely on webworkers being there 
      Radium.store.loadMany(Radium.Activity, data.feed.activities);
    }

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
