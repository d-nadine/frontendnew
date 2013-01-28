# TODO: make ends_at calculated off starts_at
Factory.define 'meeting', traits: 'timestamps',
  starts_at: -> Ember.DateTime.create()
  ends_at: -> Ember.DateTime.create().advance(hours: 1)
  topic: 'Product discussion'
  location: 'Radium HQ'
