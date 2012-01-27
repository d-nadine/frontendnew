define('controllers/feedController', function(require) {
  
  var Radium = require('radium');

  Radium.feedController = Ember.ArrayController.create({
    content: [],
    dateFilter: null,
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
    }.property('@each.timestamp').cacheable()
  });

  return Radium;
});