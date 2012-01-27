define('models/activity', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.Activity = Radium.Core.extend({
    tags: DS.attr('array'),
    timestamp: DS.attr('date'),
    owner: DS.hasOneReference({
      embedded: true,
      namespace: 'Radium'
    }),
    reference: DS.hasOneReference({
      embedded: true,
      namespace: 'Radium'
    }),
    // @returns {Ember.DateTime}
    date: function() {
      var date = new Date(this.get('timestamp')).getTime();
      return Ember.DateTime.create(date);
    }.property('timestamp').cacheable(),

    day: function() {
      return this.get('date').toFormattedString('%Y-%d');
    }.property('date').cacheable(),

    week: function() {
      return this.get('date').toFormattedString('%Y-%W');
    }.property('date').cacheable(),

    month: function() {
      return this.get('date').toFormattedString('%Y-%m');
    }.property('date').cacheable(),

    // Bind to the `timestamp` property instead of `time` property so we can 
    // calculate what quarter we're in.
    quarter: function() {
      var quarter,
          date = this.get('timestamp'),
          month = new Date(date).getMonth() + 1;
        if (month <= 3) { quarter = 1; }
        if (month > 3 && month <= 6) { quarter = 2; }
        if (month > 6 && month <= 9) { quarter = 3; }
        if (month > 9 && month <= 12) { quarter = 4; }
      return this.get('date').toFormattedString('%Y-Q') + quarter;
    }.property('timestamp').cacheable(),
    
    year: function() {
      return this.get('date').toFormattedString('%Y');
    }.property('date').cacheable()
  });
  
  return Radium;
});