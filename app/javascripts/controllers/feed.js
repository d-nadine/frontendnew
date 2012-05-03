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
    'meeting': 'Meeting'
  },

  _todoIds: [],
  _contactIds: [],
  _campaignIds: [],
  _call_listIds: [],
  _dealIds: [],
  _meetingIds: [],

  add: function(activity) {
    var content = this.get('content'),
        kind = activity.kind,
        // Parse the timestamp from the server with the proper timezone set.
        parsedDate = Ember.DateTime.parse(
            activity.timestamp, 
            Ember.DATETIME_ISO8601
        ).toFormattedString('%B %D, %Y'),
        hash = activity.timestamp.match(/(?:\d+\-\d+\-\d+)/)[0],
        ref = activity[kind] || activity.reference.kind,
        model = this.modelTypes[kind];

    if(ref) {
      Radium.store.load(Radium[model], ref);
    }

    if (!this.dates[hash]) {
      var group = Radium.FeedGroup.create({
            date: parsedDate,
            sortValue: hash,
            todos: Radium.Todo.filter(function(data) {
              var todoUpdated = data.get('created_at'),
                  lookupDate = todoUpdated.match(/(?:\d+\-\d+\-\d+)/);
              return (lookupDate[0] === hash) ? true : false;
            })
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
