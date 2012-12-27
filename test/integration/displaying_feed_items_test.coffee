module 'Integration - Displaying Feed Items'

integrationTest 'campaigns appear in the feed', ->
  expect 2
  assertEmptyFeed()

  campaign = Factory.create 'campaign'

  app ->
    Radium.get('router.feedController').pushItem campaign

  waitForFeedItem campaign, (feedItem) ->
    assertText feedItem, campaign.get('name')

integrationTest 'deals appear in the feed', ->
  expect 2
  assertEmptyFeed()

  deal = Factory.create 'deal'

  app ->
    Radium.get('router.feedController').pushItem deal

  waitForFeedItem deal, (feedItem) ->
    assertText feedItem, deal.get('name')

integrationTest 'meetings appear in the feed', ->
  expect 2
  assertEmptyFeed()

  meeting = Factory.create 'meeting'

  app ->
    Radium.get('router.feedController').pushItem meeting

  waitForFeedItem meeting, (feedItem) ->
    assertText feedItem, meeting.get('topic')

integrationTest 'todos appear in the feed', ->
  expect 2
  assertEmptyFeed()

  todo = Factory.create 'todo'

  app ->
    Radium.get('router.feedController').pushItem todo

  waitForFeedItem todo, (feedItem) ->
    assertText feedItem, todo.get('description')
