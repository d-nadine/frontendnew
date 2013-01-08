window.loadFeedFixtures = (dates)->
  feeds = []

  feeds.push
    id: Ember.DateTime.create().toDateFormat()
    date: Ember.DateTime.create().toFullFormat()
    item_ids: [
      ['todo', Factory.create('todo')]
    ]

  for i in dates
    for advance in [i, (0 - i)]
      date = Ember.DateTime.create().advance(day: advance)
      feeds.push
        id: date.toDateFormat()
        date: date.toFullFormat()
        item_ids: [
          ['todo', Factory.create('todo')]
        ]

  sorted = feeds.sort (a, b) ->
    if a.id > b.id then 1 else -1

  sorted.forEach (item, i) ->
    if previous = sorted[i - 1]
      previous.next_date =  item.id
      item.previous_date =  previous.id
    if next = sorted.objectAt(i + 1)
      next.previous_date = item.id
      item.next_date =  next.id

  for feed in sorted
    Factory.create 'feed_section', feed
