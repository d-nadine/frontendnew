Factory.define 'deal', traits: 'timestamps',
  status: 'pending'
  name: 'Great deal'
  pay_by: -> Ember.DateTime.create().advance(day: 7).toFullFormat()
