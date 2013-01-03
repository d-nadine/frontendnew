Factory.define 'campaign', traits: 'timestamps',
  name: Factory.sequence (i) -> "Campaign #{1}"
  ends_at: -> Ember.DateTime.create().advance(days: 7).toFullFormat()
