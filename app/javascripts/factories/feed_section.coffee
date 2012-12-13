Factory.define 'feed_section',
  id: -> Ember.DateTime.create().toDateFormat()
  date: -> Ember.DateTime.create().toFullFormat()
  item_ids: [
    ['todo', Factory.build('todo')]
  ]
