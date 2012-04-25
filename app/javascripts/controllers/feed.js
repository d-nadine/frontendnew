Radium.feedController = Ember.Object.create({
  /**
    Example content hash:
    
    {
      '2012-04-12': Radium.FeedGroup,
      '2012-04-11': Radium.FeedGroup
    }

  */
  content: [],

  // Lookup any stored days.
  dates: {},

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
        date = Date.parse(activity.timestamp),
        hash = activity.timestamp.match(/(?:\d+\-\d+\-\d+)/)[0],
        ref = activity.reference[kind],
        model = this.modelTypes[kind];

    // Don't load if we already gots it.
    if (this['_'+kind+'Ids'].indexOf(ref.id) < 0){
      Radium.store.load(Radium[model], ref);

      // Store every loaded ID so `DS.load` doesn't yell at us
      this['_'+kind+'Ids'].push(ref.id);
    }

    if (!this.dates[hash]) {
      var group = Radium.FeedGroup.create({
        date: date,
        todos: Radium.Todo.filter(function(data) {
          var todoUpdated = data.get('created_at'),
              lookupDate = todoUpdated.match(/(?:\d+\-\d+\-\d+)/);
          return (lookupDate[0] === hash) ? true : false;
        })
      });

      this.dates[hash] = group;
      content.insertAt(0, group);
    }
  }
});