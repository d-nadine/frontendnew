Radium.feedController = Ember.Object.extend({
  /**
    Example content hash:
    
    {
      '2012-04-12': Radium.FeedGroup,
      '2012-04-11': Radium.FeedGroup
    }

  */

  init: function() {
    var pastDates = this.looper(-1, 30),
        today = this.createDateGroup(Ember.DateTime.create()),
        futureDates = this.looper(1, 60);
    
    futureDates.pushObject(today);
    futureDates.pushObjects(pastDates);

    this.set('dates', futureDates);
  },

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

  looper: function(dir, limit) {
    var group = Ember.A([]),
        limit = this.range(limit),
        startDate = Ember.DateTime.create();
    limit.forEach(function() {
      var newDate = startDate.advance({day: dir}),
          dateGroup = this.createDateGroup(newDate);

      // tick the date up/down
      startDate = newDate;
      if (dir > 0) {
        group.insertAt(0, dateGroup);
      } else {
        group.pushObject(dateGroup);
      }
    }, this);
    return group;
  },

  createDateGroup: function(date) {
    return Radium.FeedGroup.create({
            date: date,
            sortValue: date.toFormattedString('%Y-%m-%d')
          });
  },

  dates: Ember.A([]),

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

  add: function(activity) {

    var content = this.get('content'),
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

    if (!this.dates[hash]) {
      var group = Radium.FeedGroup.create({
            date: parsedDate,
            sortValue: hash,
          }),
          length = this.getPath('content.length'),
          idx = this.binarySearch(group.get('sortValue'), 0, length);

      this.dates[hash] = group;
      content.insertAt(idx, group);
    }
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
  },
});
