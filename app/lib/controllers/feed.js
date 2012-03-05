Radium.feedController = Ember.ArrayProxy.extend({
  selectedUser: null,
  selectedDate: 'day',
  dateFilter: 'day',
  dataCache: Ember.A([]),
  // days: function() {
  //   return this.mapProperty('day').uniq();
  // }.property('@each.updatedAt').cacheable(),
  
  // weeks: function() {
  //   return this.mapProperty('week').uniq();
  // }.property('@each.updatedAt').cacheable(),

  // months: function() {
  //   return this.mapProperty('month').uniq();
  // }.property('@each.updatedAt').cacheable(),
  
  // quarters: function() {
  //   return this.mapProperty('quarter').uniq();
  // }.property('@each.updatedAt').cacheable(),

  // years: function() {
  //   return this.mapProperty('year').uniq();
  // }.property('@each.updatedAt').cacheable(),
  days: function() {
    return this.get('dataCache').filterProperty('type', 'day');
  }.property('dataCache').cacheable(),
  weeks: function() {
    return this.get('dataCache').filterProperty('type', 'week');
  }.property('dataCache').cacheable(),
  months: function() {
    return this.get('dataCache').filterProperty('type', 'month');
  }.property('dataCache').cacheable(),
  quarters: function() {
    return this.get('dataCache').filterProperty('type', 'quarter');
  }.property('dataCache').cacheable(),
  years: function() {
    return this.get('dataCache').filterProperty('type', 'year');
  }.property('dataCache').cacheable(),

  arrayDidChange: function(content, idx, removedCnt, addedCnt) {
    var self = this,
        // Grab only new array items
        newActivities = content.slice(idx);

    var createDateGroup = function(day, type, activityType, item) {
      var dayGroup = Ember.Object.create({
        date: day,
        datetime: item.get('date'),
        type: type,
        todos: Ember.A([]),
        todosUpdated: function() {
          console.log('new todos!');
        }.observes('todos'),
        todoIds: function() {
          console.log(this.get('todos').mapProperty('referenceID').uniq());
          return this.get('todos').mapProperty('referenceID').uniq();
        }.property('todos').cacheable(),
        createdTodos: function() {
          return this.get('todos').filterProperty('action', 'created');
        }.property('todos').cacheable(),
        assignedTodos: function() {
          return this.get('todos').filterProperty('action', 'assigned');
        }.property('todos').cacheable(),
        finishedTodos: function() {
          return this.get('todos').filterProperty('action', 'finished');
        }.property('todos').cacheable(),
        deals: Ember.A([]),
        meetings: Ember.A([]),
        campaigns: Ember.A([]),
        calllists: Ember.A([]),
        contacts: Ember.A([])
      });
      dayGroup.get(activityType).pushObject(item);
      return dayGroup;
    };
    console.log('chchchcage!');
        
    // Goes through only newly added array items
    newActivities.forEach(function(item) {
      var day = item.get('day'),
          week = item.get('week'),
          month = item.get('month'),
          quarter = item.get('quarter'),
          year = item.get('year'),
          activityType =  item.get('type') + 's',
          cache = self.get('dataCache');
      
      // Map and check if the date group has already been stored in memory.
      var map = cache.mapProperty('date'),
          dayIdx = map.indexOf(day),
          weekIdx = map.indexOf(week),
          monthIdx = map.indexOf(month),
          quarterIdx = map.indexOf(quarter),
          yearIdx = map.indexOf(year);
      
      // FIXME: This can probably reduced to a simpler loop
      // Day
      if (dayIdx < 0) {
        cache.pushObject(createDateGroup(day, 'day', activityType, item));
      } else {
        cache.objectAt(dayIdx).get(activityType).pushObject(item);
      }
      // Week
      if (weekIdx < 0) {
        cache.pushObject(createDateGroup(week, 'week', activityType, item));
      } else {
        cache.objectAt(weekIdx).get(activityType).pushObject(item);
      }

      // Month
      if (monthIdx < 0) {
        cache.pushObject(createDateGroup(month, 'month', activityType, item));
      } else {
        cache.objectAt(monthIdx).get(activityType).pushObject(item);
      }

      // Quarter
      if (quarterIdx < 0) {
        cache.pushObject(createDateGroup(quarter, 'quarter', activityType, item));
      } else {
        cache.objectAt(quarterIdx).get(activityType).pushObject(item);
      }

      // Year
      if (yearIdx < 0) {
        cache.pushObject(createDateGroup(year, 'year', activityType, item));
      } else {
        cache.objectAt(yearIdx).get(activityType).pushObject(item);
      }
    });

    // Made our calculations, carry on then.
    this._super(content, idx, removedCnt, addedCnt);

  },

  selectedDateType: function() {
    var selectedDateFilter = this.get('dateFilter');
    // Test for a date string, and if so fetch that locally
    if (selectedDateFilter.match('-')) {
      return false;
    } else {
      // Pluralize this here so Radium.FeedDateItemView can filter singularly
      return this.get(selectedDateFilter + 's');
    }
  }.property('@each.updatedAt', 'dateFilter').cacheable()
});