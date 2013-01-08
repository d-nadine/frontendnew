module 'Integration - Feed'

integrationTest 'feed type gets clustered after reaching the cluster size', ->
  expect(4)
  assertEmptyFeed()

  date = Ember.DateTime.create()

  app ->
    for i in [0..8]
      todo = Factory.create 'todo'
        finish_by: date.toFullFormat()

      Radium.get('router.activeFeedController').pushItem todo

  waitForFeedDate date, (section) ->
    assertFeedItems 0
    assertClusters 1
    assertText section, '9 todos'

integrationTest 'a feed can be filtered by feed type', ->
  expect(7)

  assertEmptyFeed()

  date = Ember.DateTime.create()

  app ->
    controller = Radium.get('router.activeFeedController')

    controller.pushItem Factory.create 'todo'
      finish_by: date.toFullFormat()

    controller.pushItem Factory.create 'deal'
      close_by: date.toFullFormat()

    controller.pushItem Factory.create 'campaign'
      ends_at: date.toFullFormat()

    controller.pushItem Factory.create 'meeting'
      starts_at: date.toFullFormat()

  waitForFeedDate date, (el) ->
    assertFeedItems(4)

    clickFilterAndAssertFeedItems 'todo', 1
    clickFilterAndAssertFeedItems 'deal', 1
    clickFilterAndAssertFeedItems 'campaign', 1
    clickFilterAndAssertFeedItems 'meeting', 1
    clickFilterAndAssertFeedItems 'all', 4

integrationTest 'a feed can retrieve new items from infinite scrolling in both directions', ->
  expect(3)

  assertEmptyFeed()

  loadFeedFixtures [
    Ember.DateTime.create().advance(day: -7),
    Ember.DateTime.create(),
    Ember.DateTime.create().advance(day: 7)
  ]

  controller = Radium.get('router.activeFeedController')

  todo = Factory.create 'todo'

  app -> controller.pushItem todo

  waitForFeedItem todo, (el) ->
    assertScrollingFeedHasDate(controller, 7, forward: true)
    assertScrollingFeedHasDate(controller, -7, backward: true)

integrationTest 'a feed can jump to a specific date', ->
  expect(4)
  assertEmptyFeed()

  futureDate = Ember.DateTime.create().advance(day: 14)
  loadFeedFixtures [futureDate]

  router = Radium.get('router')

  todo = Factory.create 'todo'

  app ->
    Radium.get('router.activeFeedController').pushItem todo

  waitForFeedItem todo, ->
    assertFeedItems 1

    app ->
      # FIXME: why does this not worK? Or what is the proper way to use send?
      # router.send 'scrollFeedToDate', date: futureDate
      router.set 'activeFeedController.currentDate', futureDate

    waitForFeedDate futureDate, ->
      assertFeedItems 2
      ok true, "#{futureDate.toDateFormat()} loaded via jumping"
