Factory.define 'deal', traits: 'timestamps',
  state: 'pending'
  name: 'Great deal'
  close_by: -> Ember.DateTime.create().advance(day: 7).toFullFormat()
