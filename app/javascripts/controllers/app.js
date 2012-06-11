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

    var worker = new Worker('worker.js');

    console.log('about to send' + urls.length + ' requests');

    var replies = 0;

    worker.addEventListener('message', function(e){
      try{
        var activities = JSON.parse(e.data).feed.activities;
        replies += 1;
        console.log('replies = ' + replies);
        if(activities.length > 0){
          Radium.store.loadMany(Radium.Activity, activities);
        }
      }catch(err){
        console.error(err);
      }
    });

    worker.addEventListener('error', function(e){
      worker.terminate();
    });

    worker.postMessage({
      key: CONFIG.api,
      urls: urls
    });
  },
  bootstrap: function(data){
    if(Radium.Utils.browserSupportsWebWorkers()){
      this.createDataStoreWorker(data);
    }else{  
      //TODO: What to do or can we rely on webworkers being there 
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
