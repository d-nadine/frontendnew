Factory.define 'deal', traits: 'timestamps',
  state: 'pending'
  name: 'Great deal'
  close_by: -> Ember.DateTime.create().advance(days: 7).toFullFormat()
  user: -> Factory.build 'user'
