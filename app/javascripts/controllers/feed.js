Radium.feedController = Ember.Object.extend({
  /**
    Example content hash:
    
    {
      '2012-04-12': Radium.FeedGroup,
      '2012-04-11': Radium.FeedGroup
    }

  */

  // Lifted from Underscore.js
  range: function(start, stop, step) {
    if (arguments.length <= 1) {
      stop = start || 0;
      start = 0;
    }
    step = arguments[2] || 1;

    var len = Math.max(Math.ceil((stop - start) / step), 0);
    var idx = 0;
    var range = new Array(len);

    while(idx < len) {
      range[idx++] = start;
      start += step;
    }

    return range;
  },

  /**
    @param {Object} options `limit` number of dates to start with, `direction` future or past
  */
  createDateRange: function(options) {
    var settings = {
      limit: 10,
      direction: -1
    };

    var settings = $.extend({}, settings, options);

    var group = Ember.A([]),
        dateLimit = this.range(settings.limit),
        startDate = Ember.DateTime.create();

    dateLimit.forEach(function(item, idx) {
      var newDate = startDate.advance({day: settings.direction}),
          lookupValue = newDate.toFormattedString('%Y-%m-%d'),
          dateGroup = this.createDateGroup(newDate);

      this._pastDateHash[lookupValue] = dateGroup;
      // tick the date up/down
      startDate = newDate;
      if (settings.direction > 0) {
        group.insertAt(0, dateGroup);
      } else {
        group.pushObject(dateGroup);
      }
    }, this);

    return group;
  },

  createDateGroup: function(date) {
    var dateValue = date || Ember.DateTime.create();
    return Radium.FeedGroup.create({
            content: Ember.A([]),
            date: dateValue,
            sortValue: dateValue.toFormattedString('%Y-%m-%d')
          });
  },


  datesWithContent: function() {
    return this.get('dates').filter(function(date) {
      var kind = date.get('dateKind');
      if (kind === 'today' || date.get('hasVisibleContent')) {
        return true;
      } else {
        return false;
      }
    });
  }.property('dates', 'dates.@each.hasVisibleContent').cacheable(),

  modelTypes: {
    'todo': 'Todo',
    'contact': 'Contact',
    'campaign': 'Campaign',
    'call_list': 'CallList',
    'deal': 'Deal',
    'meeting': 'Meeting',
    'email': 'Email'
  },

  oldestHistoricalDateBinding: 'Radium.accountController.content.createdAt',
  lastDateLoaded: Ember.DateTime.create(),
  // Checks if the last date loaded is the same day or older than the oldest
  // date of the account, since no
  isAllHistoricalLoaded: function() {
    var oldestDateLoaded = this.get('oldestDateLoaded'),
        lastDateLoaded = this.get('lastDateLoaded');
    return Ember.DateTime.compare(oldestDateLoaded, lastDateLoaded) >= 0;
  }.property('oldestDateLoaded', 'lastDateLoaded'),

  isLoading: false,
  daysLoaded: 0,

  loadDates: function() {
    var self = this,
        feedUrl = this.get('feedUrl'),
        userId = this.get('userId'),
        oldestHistoricalDate = this.get('oldestHistoricalDate'),
        lastDateLoaded = this.get('lastDateLoaded'),
        offset = (this.get('daysLoaded') === 0) ? 0 : -1,
        day = lastDateLoaded.advance({day: offset});

    Radium.Activity.reopenClass({
      url: feedUrl,
      root: 'activity'
    });
    
    this.set('isLoading', true);
    
    var activities = Radium.store.find(Radium.Activity, {
          end_date: day.toFormattedString('%Y-%m-%d'), 
          start_date: day.toFormattedString('%Y-%m-%d')
        });
    
    activities.addObserver('isLoaded', function() {
      self.setProperties({
        lastDateLoaded: day,
        isLoading: false
      });
      
      self.incrementProperty('daysLoaded');

      if (activities.get('length') === 0) {
        self.loadDates();
      } else {
        activities.forEach(function(activity) {
          if (activity.get('tag') === 'scheduled_for') {
            var kind = activity.get('kind'),
                reference = activity.get(kind)
          } else {
            self.addToFeed(activity);
          }
        }, self);
      }
    });

    Radium.Activity.reopenClass({
      url: null,
      root: null
    });
  },

  addToFeed: function(activity) {
    var date = activity.get('timestamp')
                .adjust({timezone: CONFIG.dates.timezone})
                .toFormattedString('%Y-%m-%d'),
        dateGroup = this._pastDateHash[date];
    if (dateGroup) {
      dateGroup.get('content').pushObject(activity);
    }
  },

  add: function(activity) {

    var content = this.get('content'),
        pastDates = this.get('pastDates'),
        kind = activity.kind,
        timezone = new Date().getTimezoneOffset(),
        // Parse the timestamp from the server with the proper timezone set.
        parsedDate = Ember.DateTime.parse(
            activity.timestamp, 
            Ember.DATETIME_ISO8601
        ).adjust({timezone: timezone}),
        dateString = parsedDate.toFormattedString('%B %D, %Y'),
        hash = parsedDate.toFormattedString('%Y-%m-%d'),
        ref = activity[kind] || activity.reference[kind],
        model = this.modelTypes[kind];
    
    // Normalize the activity
    activity[kind] = ref;
    activity.user = (activity.owner) ? activity.owner.user : null;

    if (activity.scheduled) {
      ref.activity = activity;
    }

    Radium.store.load(Radium.Activity, activity);
    Radium.store.load(Radium[model], ref);

    var dateGroup = pastDates.find(function(date) {
      return date.get('sortValue') === hash;
    });

    if (dateGroup) {
      dateGroup.get('content').pushObject(Radium.store.find(Radium.Activity, activity.id));
    } else {
      var pastDate = this.createDateGroup(parsedDate);
      pastDate.get('content').pushObject(Radium.store.find(Radium.Activity, activity.id));
      pastDates.pushObject(pastDate);
    }

    // if (!this.dates[hash]) {
    //   var group = Radium.FeedGroup.create({
    //         date: parsedDate,
    //         sortValue: hash,
    //       }),
    //       length = this.getPath('content.length'),
    //       idx = this.binarySearch(group.get('sortValue'), 0, length);

    //   this.dates[hash] = group;
    //   content.insertAt(idx, group);
    // }
  },

  binarySearch: function(value, low, high) {
    var mid, midValue;

    if (low === high) {
      return low;
    }

    mid = low + Math.floor((high - low) / 2);
    midValue = this.get('content').objectAt(mid).get('sortValue');

    if (value < midValue) {
      return this.binarySearch(value, mid+1, high);
    } else if (value > midValue) {
      return this.binarySearch(value, low, mid);
    }

    return mid;
  }
});
