module 'Integration - Displaying Feed Items'

integrationTest 'todos appear in the feed', ->
  expect(3)

  assertEmptyFeed()

  section = Factory.create 'feed_section'
  todo = Factory.create 'todo',
          description: 'Finish programming radium'

  app ->
    Radium.get('router.feedController').pushItem todo

  waitForResource section, (el) ->
    assertFeedItems 1
    assertText el, 'Finish programming radium'
