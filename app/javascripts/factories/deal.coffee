Factory.define 'deal', traits: 'timestamps',
  state: 'pending'
  name: 'Great deal'
  closeBy: -> Ember.DateTime.create().advance(days: 7)
