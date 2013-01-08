window.loadFeedFixtures = (dates)->
  feeds = []

  for date in dates
    todo = Factory.create('todo', finish_by: date.toFullFormat())

    feeds.push
      id: date.toDateFormat()
      date: date.toFullFormat()
      item_ids: [
        [Radium.Todo, todo.get('id')]
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
    Radium.FeedSection.FIXTURES.push feed
