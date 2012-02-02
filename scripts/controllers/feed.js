define('controllers/feedController', function(require) {
  
  var Radium = require('radium');

  Radium.feedController = Ember.ArrayProxy.create({
    content: [],
    days: function() {
      return this.mapProperty('day').uniq();
    }.property('@each.timestamp').cacheable(),
    
    weeks: function() {
      return this.mapProperty('week').uniq();
    }.property('@each.timestamp').cacheable(),

    months: function() {
      return this.mapProperty('month').uniq();
    }.property('@each.timestamp').cacheable(),
    
    quarters: function() {
      return this.mapProperty('quarter').uniq();
    }.property('@each.timestamp').cacheable(),

    years: function() {
      return this.mapProperty('year').uniq();
    }.property('@each.timestamp').cacheable(),

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
          
      // Goes through only newly added array items
      newActivities.forEach(function(item) {
        var day = item.get('day'),
            week = item.get('week'),
            month = item.get('month'),
            quarter = item.get('quarter'),
            year = item.get('year'),
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
          cache.pushObject(Ember.Object.create({
            date: day,
            type: 'day',
            items: Ember.A([item])
          }));
        } else {
          cache.objectAt(dayIdx).get('items').pushObject(item);
        }

        // Week
        if (weekIdx < 0) {
          cache.pushObject(Ember.Object.create({
            date: week,
            type: 'week',
            items: Ember.A([item])
          }));
        } else {
          cache.objectAt(weekIdx).get('items').pushObject(item);
        }

        // Month
        if (monthIdx < 0) {
          cache.pushObject(Ember.Object.create({
            date: month,
            type: 'month',
            items: Ember.A([item])
          }));
        } else {
          cache.objectAt(monthIdx).get('items').pushObject(item);
        }

        // Quarter
        if (quarterIdx < 0) {
          cache.pushObject(Ember.Object.create({
            date: quarter,
            type: 'quarter',
            items: Ember.A([item])
          }));
        } else {
          cache.objectAt(quarterIdx).get('items').pushObject(item);
        }

        // Year
        if (yearIdx < 0) {
          cache.pushObject(Ember.Object.create({
            date: year,
            type: 'year',
            items: Ember.A([item])
          }));
        } else {
          cache.objectAt(yearIdx).get('items').pushObject(item);
        }
      });

      // Made our calculations, carry on then.
      this._super(content, idx, removedCnt, addedCnt);

    }
  });

  return Radium;
});