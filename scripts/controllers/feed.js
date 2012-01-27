define('controllers/feedController', function(require) {
  
  var Radium = require('radium');

  Radium.feedController = Ember.ArrayController.create({
    content: [],
    sorted: [],
    dateFilter: null,
    days: function() {
      return this.mapProperty('day').uniq();
    }.property('@each.timestamp').cacheable(),
    
    months: function() {
      return this.mapProperty('month').uniq();
    }.property('@each.timestamp').cacheable(),
    
    years: function() {
      return this.mapProperty('year').uniq();
    }.property('@each.timestamp').cacheable(),

    createDateRecords: function() {
      console.log('hiiii');
      this.beginPropertyChanges();
      var content = this.get('content'),
          days = this.get('days'),
          months = this.get('months'),
          years = this.get('years');

      days.forEach(function(item) {
        var obj = {date: item, items: content.filterProperty('day', item)};
        this.sorted.push(obj);
      }, this);
      this.endPropertyChanges();

    }.observes('content'),
    // arrayDidChange: function() {
    //   this.createDateRecords();
    //   this._super();
    // }
  });

  return Radium;
});