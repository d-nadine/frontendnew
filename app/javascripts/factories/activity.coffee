Factory.define 'activity',
  timestamp: -> Ember.DateTime.random past: true
