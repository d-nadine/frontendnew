module 'Integration - Displaying Feed Items'

integrationTest 'campaigns appear in the feed', ->
  expect 3
  assertEmptyFeed()

  campaign = Factory.create 'campaign'

  app ->
    Radium.get('router.activeFeedController').pushItem campaign

  waitForFeedItem campaign, (feedItem) ->
    assertText feedItem, campaign.get('name')

    clickFeedItem feedItem

    fillInAndPressEnter $F('.new-comment', feedItem), 'Test Comment'

    assertText feedItem, 'Test Comment'

integrationTest 'deals appear in the feed', ->
  expect 3
  assertEmptyFeed()

  deal = Factory.create 'deal'

  app ->
    Radium.get('router.activeFeedController').pushItem deal

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
    Radium.get('router.activeFeedController').pushItem meeting

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
    Radium.get('router.activeFeedController').pushItem todo

  waitForFeedItem todo, (feedItem) ->
    assertText feedItem, todo.get('description')

    clickFeedItem feedItem

    fillInAndPressEnter $F('.new-comment', feedItem), 'Test Comment'

    assertText feedItem, 'Test Comment'
