# TODO: make ends_at calculated off starts_at
Factory.define 'meeting', traits: 'timestamps',
  starts_at: -> Ember.DateTime.create().toFullFormat()
  ends_at: -> Ember.DateTime.create().advance(hours: 1).toFullFormat()
  topic: 'Product discussion'
  location: 'Radium HQ'
  user: -> Factory.build 'user'
  users: -> [
    Factory.build('user'),
    Factory.build('user')
  ]
