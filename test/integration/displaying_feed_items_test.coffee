module 'Integration - Displaying Feed Items'

integrationTest 'campaigns appear in the feed', ->
  expect 3
  assertEmptyFeed()

  campaign = Factory.create 'campaign'

  app ->
    Radium.get('router.feedController').pushItem campaign

  waitForFeedItem campaign, (el) ->
    assertFeedItems 1
    assertText el, campaign.get('name')

integrationTest 'deals appear in the feed', ->
  expect 3
  assertEmptyFeed()

  deal = Factory.create 'deal'

  app ->
    Radium.get('router.feedController').pushItem deal

  waitForFeedItem deal, (el) ->
    assertFeedItems 1
    assertText el, deal.get('name')

integrationTest 'meetings appear in the feed', ->
  expect 3
  assertEmptyFeed()

  meeting = Factory.create 'meeting'

  app ->
    Radium.get('router.feedController').pushItem meeting

  waitForFeedItem meeting, (el) ->
    assertFeedItems 1
    assertText el, meeting.get('topic')

integrationTest 'todos appear in the feed', ->
  expect 3
  assertEmptyFeed()

  todo = Factory.create 'todo'

  app ->
    Radium.get('router.feedController').pushItem todo

  waitForFeedItem todo, (el) ->
    assertFeedItems 1
    assertText el, todo.get('description')
