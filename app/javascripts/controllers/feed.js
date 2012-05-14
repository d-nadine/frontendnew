Radium.feedController = Ember.Object.extend({
  /**
    Example content hash:
    
    {
      '2012-04-12': Radium.FeedGroup,
      '2012-04-11': Radium.FeedGroup
    }

  */

  modelTypes: {
    'todo': 'Todo',
    'contact': 'Contact',
    'campaign': 'Campaign',
    'call_list': 'CallList',
    'deal': 'Deal',
    'meeting': 'Meeting',
    'email': 'Email'
  },

  _todoIds: [],
  _contactIds: [],
  _campaignIds: [],
  _call_listIds: [],
  _dealIds: [],
  _meetingIds: [],
  _emailIds: [],

  add: function(activity) {
    var content = this.get('content'),
        kind = activity.kind,
        // Parse the timestamp from the server with the proper timezone set.
        parsedDate = Ember.DateTime.parse(
            activity.timestamp, 
            Ember.DATETIME_ISO8601
        ),
        dateString = parsedDate.toFormattedString('%B %D, %Y'),
        hash = parsedDate.toFormattedString('%Y-%m-%d'),
        ref = activity[kind] || activity.reference[kind],
        model = this.modelTypes[kind];
    
    // Normalize the activity
    activity[kind] = ref;

    Radium.store.load(Radium.Activity, activity);

    if (!this.dates[hash]) {
      var group = Radium.FeedGroup.create({
            date: dateString,
            sortValue: hash,
            ongoing: Radium.Activity.filter(function(data) {
              var timestamp = data.get('timestamp'),
                  lookupDate = timestamp.match(Radium.Utils.DATES_REGEX.monthDayYear),
                  regex = new RegExp(lookupDate[0]);
              return regex.test(hash) 
                    && data.get('scheduled')
                    && !data.get('todo').finished;
            }),
            sortedOngoing: function() {
              return this.get('ongoing').slice(0).sort(function(a, b) {
                var date1 = a.get('timestamp'),
                    date2 = b.get('timestamp');

                if (date1 > date2) return 1;
                if (date1 < date2) return -1;
                return 0;
              });
            }.property('ongoing.@each').cacheable(),

            historical: Radium.Activity.filter(function(data) {
              var timestamp = data.get('timestamp'),
                  lookupDate = timestamp.match(Radium.Utils.DATES_REGEX.monthDayYear);
              return lookupDate[0] === hash && data.get('scheduled') !== true;
            }),
            sortedHistorical: function() {
              return this.get('historical').slice(0).sort(function(a, b) {
                return a.get('timestamp') - b.get('timestamp');
              });
            }.property('historical.@each').cacheable()
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
