module 'Integration - Feed'

integrationTest 'adding a meeting shows it in the feed', ->
  expect(3)

  assertEmptyFeed()

  waitForSelector '.filters .add-meeting', (el) ->
    click el

    waitForSelector '#form-container', (el) ->
      meetingDate = Ember.DateTime.create().advance(day: 7)

      fillIn '#start-date', meetingDate.toDateFormat()
      fillIn '#description', 'New meeting'

      click '.btn-success'

      feedSelector = ".feed_section_#{meetingDate.toDateFormat()}"

      waitForSelector feedSelector, (el) ->
        assertFeedItems(1)
        assertText el, 'New meeting'

integrationTest 'todos appear in the feed', ->
  expect(3)

  assertEmptyFeed()

  section = Factory.create 'feed_section'
  todo = Factory.create 'todo',
          description: 'Finish programming radium'

  app ->
    Radium.get('router.feedController').pushItem todo

  feedSelector = ".feed_section_#{section.get('id')}"

  waitForSelector feedSelector, (el) ->
    assertFeedItems 1
    assertText el, 'Finish programming radium'

integrationTest 'feed type gets clustered after reaching the cluster size', ->
  expect(3)
  assertEmptyFeed()

  section = Factory.create 'feed_section'

  app ->
    for i in [0..8]
      todo = Factory.create 'todo'
      Radium.get('router.feedController').pushItem todo

  waitForResource section, (el) ->
    assertFeedItems 0
    assertText el, '9 todos'

integrationTest 'comment can be added to feed item', ->
  expect(2)

  section = Factory.create 'feed_section'
  todo = Factory.create 'todo'

  app ->
    Radium.get('router.feedController').pushItem todo

  waitForResource todo, (el) ->
    click el

    waitForSelector ['.comments', el.parent()], (commentsContainer) ->
      textArea = $('.new-comment', commentsContainer)
      ok textArea.length, "Comments box missing"

      fillInAndPressEnter(textArea, "Bravo!")

      comments = $('.comments', commentsContainer)
      condition = -> comments.length == 2

      waitForSelector ".comment-text", (coms)->
        assertText coms, "Bravo!"
