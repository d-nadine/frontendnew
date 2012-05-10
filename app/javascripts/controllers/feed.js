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
        ).toFormattedString('%B %D, %Y'),
        hash = activity.timestamp.match(Radium.Utils.DATES_REGEX.monthDayYear)[0],
        ref = activity[kind] || activity.reference[kind],
        model = this.modelTypes[kind];
    console.log(kind, activity.tag);
    // Normalize the activity
    activity[kind] = ref;

    Radium.store.load(Radium.Activity, activity);

    if (ref) {
      Radium.store.load(Radium[model], ref);
    }

    if (!this.dates[hash]) {
      var group = Radium.FeedGroup.create({
            date: parsedDate,
            sortValue: hash,
            ongoing: Radium.Todo.filter(function(data) {
              var updated = data.get('created_at'),
                  lookupDate = updated.match(Radium.Utils.DATES_REGEX.monthDayYear);
              return lookupDate[0] === hash && data.get('finished') === false;
            }),
            sortedOngoing: function() {
              return this.get('ongoing').slice(0).sort(function(a, b) {
                return a.get('timestamp') - b.get('timestamp');
              });
            }.property('ongoing.@each').cacheable(),

            historical: Radium.Activity.filter(function(data) {
              var timestamp = data.get('created_at'),
                  lookupDate = timestamp.match(Radium.Utils.DATES_REGEX.monthDayYear);
              return lookupDate[0] === hash && data.get('tag') !== 'scheduled';
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
