module 'Integration - Displaying Feed Items'

integrationTest 'deals appear in the feed', ->
  expect 3
  assertEmptyFeed()

  deal = Factory.create 'deal'

  app ->
    Radium.get('router.activeFeedController').pushObject deal

  waitForFeedItem deal, (feedItem) ->
    assertText feedItem, deal.get('name')

    clickFeedItem feedItem

    fillInAndPressEnter $F('.new-comment', feedItem), 'Test Comment'

    assertText feedItem, 'Test Comment'

integrationTest 'meetings appear in the feed', ->
  expect 3
  assertEmptyFeed()

  meeting = Factory.create 'meeting'

  app ->
    Radium.get('router.activeFeedController').pushObject meeting

  waitForFeedItem meeting, (feedItem) ->
    assertText feedItem, meeting.get('topic')

    clickFeedItem feedItem

    fillInAndPressEnter $F('.new-comment', feedItem), 'Test Comment'

    assertText feedItem, 'Test Comment'

integrationTest 'todos appear in the feed', ->
  expect 3
  assertEmptyFeed()

  todo = Factory.create 'todo'

  app ->
    Radium.get('router.activeFeedController').pushObject todo

  waitForFeedItem todo, (feedItem) ->
    assertText feedItem, todo.get('description')

    clickFeedItem feedItem

    fillInAndPressEnter $F('.new-comment', feedItem), 'Test Comment'

    assertText feedItem, 'Test Comment'
