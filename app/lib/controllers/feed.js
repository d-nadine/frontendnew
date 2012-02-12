Radium.feedController = Ember.ArrayProxy.extend({

  /**
    Override the `arrayDidChange` so only any newly added chunks of 
    activities can be added to the `Radium.activityDateGroupsController` 
    instead of making increasingly expensive enumerable calls when switching 
    date filters.
  */
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
        deals: Ember.A([]),
        meetings: Ember.A([]),
        campaigns: Ember.A([]),
        calls: Ember.A([])
      });
      dayGroup.get(activityType).pushObject(item);
      return dayGroup;
    };
        
    // Goes through only newly added array items
    newActivities.forEach(function(item) {
      var day = item.get('day'),
          week = item.get('week'),
          month = item.get('month'),
          quarter = item.get('quarter'),
          year = item.get('year'),
          activityType =  item.get('activityType') + 's',
          // Cache `Radium.activityDateGroupsController`
          cache = Radium.activityDateGroupsController.get('content');
      
      // Map and check if the date group has already been stored in memory.
      var map = cache.mapProperty('date');
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

  }
});