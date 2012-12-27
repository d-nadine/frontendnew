module 'Integration - Displaying Feed Items'

integrationTest 'campaigns appear in the feed', ->
  expect 3
  assertEmptyFeed()

  campaign = Factory.create 'campaign'

  app ->
    Radium.get('router.feedController').pushItem campaign

  waitForResource campaign, (el) ->
    assertFeedItems 1
    assertText el, campaign.get('name')

integrationTest 'deals appear in the feed', ->
  expect 3
  assertEmptyFeed()

  deal = Factory.create 'deal'

  app ->
    Radium.get('router.feedController').pushItem deal

  waitForResource deal, (el) ->
    assertFeedItems 1
    assertText el, deal.get('name')

integrationTest 'meetings appear in the feed', ->
  expect 3
  assertEmptyFeed()

  meeting = Factory.create 'meeting'

  app ->
    Radium.get('router.feedController').pushItem meeting

  waitForResource meeting, (el) ->
    assertFeedItems 1
    assertText el, meeting.get('topic')

integrationTest 'todos appear in the feed', ->
  expect 3

  assertEmptyFeed()

  todo = Factory.create 'todo'

  app ->
    Radium.get('router.feedController').pushItem todo

  waitForResource todo, (el) ->
    assertFeedItems 1
    assertText el, todo.get('description')
