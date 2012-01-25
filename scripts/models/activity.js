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

    // TODO: This might be faster as just native Date Object manipulation
    // If performance is slow, revisit.
    day: function() {
      var date = new Date(this.get('timestamp')).getTime();
      return Ember.DateTime.create(date).toFormattedString('%d');
    }.property('timestamp').cacheable(),
    month: function() {
      var date = new Date(this.get('timestamp')).getTime();
      return Ember.DateTime.create(date).toFormattedString('%m');
    }.property('timestamp').cacheable(),
    year: function() {
      var date = new Date(this.get('timestamp')).getTime();
      return Ember.DateTime.create(date).toFormattedString('%Y');
    }.property('timestamp').cacheable()
  });
  
  return Radium;
});