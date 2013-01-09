module 'Integration - Gap Elements'

integrationTest 'feed detects gaps', ->
  today = Ember.DateTime.create()
  tomorrow = Ember.DateTime.create().advance day: 1
  nextWeek = Ember.DateTime.create().advance day: 7

  todaysTodo = Factory.create 'todo'
  tomorrowsTodo = Factory.create 'todo',
    finish_by: tomorrow.toFullFormat()
  nextWeeksTodo = Factory.create 'todo',
    finish_by: nextWeek.toFullFormat()

  Radium.FeedSection.FIXTURES = [
    {
      id: today.toDateFormat()
      date: today.toFullFormat()
      item_ids: [
        [Radium.Todo, todaysTodo.get('id')]
      ]
      next_date: tomorrow.toDateFormat()
    },
    {
      id: tomorrow.toDateFormat()
      date: tomorrow.toFullFormat()
      item_ids: [
        [Radium.Todo, tomorrowsTodo.get('id')]
      ]
      previous_date: today.toDateFormat()
      next_date: nextWeek.toDateFormat()
    },
    {
      id: nextWeek.toDateFormat()
      date: nextWeek.toFullFormat()
      item_ids: [
        [Radium.Todo, nextWeeksTodo.get('id')]
      ]
      previous_date: tomorrow.toDateFormat()
    }
  ]

  assertEmptyFeed()

  app ->
    Radium.get('router.activeFeedController').pushObject todaysTodo
    Radium.get('router.activeFeedController').pushObject nextWeeksTodo

  waitForSelector "#main-feed .gap", (gap) ->
    ok true, "Gap present"
    click gap

  assertInFeed tomorrowsTodo
