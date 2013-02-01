# TODO: make ends_at calculated off starts_at
Factory.define 'meeting', traits: 'timestamps',
  startsAt: -> Ember.DateTime.create()
  endsAt: -> Ember.DateTime.create().advance(hours: 1)
  topic: 'Product discussion'
  location: 'Radium HQ'
