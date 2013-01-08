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
  expect(4)

  assertEmptyFeed()

  loadFeedFixtures([8, 14])

  controller = Radium.get('router.activeFeedController')

  app ->
    controller.pushItem Factory.create 'todo'

  feedSelector = ".feed_section_#{Ember.DateTime.create().toDateFormat()}"

  waitForSelector feedSelector, (el) ->
    assertFeedItems 1

    assertScrollingFeedHasDate(controller, 14, forward: true)
    assertScrollingFeedHasDate(controller, -14, back: true)

integrationTest 'a feed can jump to a specific date', ->
  expect(2)

  assertEmptyFeed()

  loadFeedFixtures([8, 14, 27])

  controller = Radium.get('router.activeFeedController')
  router = Radium.get('router')

  app ->
    controller.pushItem Factory.create 'todo'

  feedSelector = ".feed_section_#{Ember.DateTime.create().toDateFormat()}"

  waitForSelector feedSelector, (el) ->
    futureDate = Ember.DateTime.create().advance(day: 27)

    app ->
      router.send 'scrollFeedToDate', date: futureDate.toDateFormat()

    waitForSelector ".feed_section_#{futureDate.toDateFormat()}", (el) ->
      assertText el, futureDate.toFormattedString('%A, %B %D, %Y')
