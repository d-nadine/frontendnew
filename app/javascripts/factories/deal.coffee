Factory.define 'deal', traits: 'timestamps',
  status: 'pending'
  name: 'Great deal'
  payBy: Ember.DateTime.create().advance(day: 7)
  contact: -> Factory.create 'contact'
