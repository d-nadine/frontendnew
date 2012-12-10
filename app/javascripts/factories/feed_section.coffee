Factory.define 'FeedSection',
  id: -> Ember.DateTime.create().toDateFormat()
  date: -> Ember.DateTime.create().toFullFormat()
  item_ids: []
