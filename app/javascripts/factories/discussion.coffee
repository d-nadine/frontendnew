Factory.define 'discussion', traits: 'timestamps',
  topic: 'deal discussion'
  sentAt: -> Ember.DateTime.random()
