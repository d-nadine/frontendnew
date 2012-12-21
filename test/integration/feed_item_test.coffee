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

integrationTest 'comment can be added to feed item', ->
  expect(3)

  section = $W.Factory.create 'feed_section'
  todo = $W.Factory.create 'todo'

  $W.Ember.run ->
    $A.get('router.feedController').pushItem todo

  event = $F.Event("keypress")
  event.keyCode = 13

  waitForResource todo, (el) ->
    ok true, 'got here'

    el.click()

    waitForSelector ['.comments', el.parent()], (commentsContainer) ->
      textArea = $('.new-comment', commentsContainer)
      ok textArea.length, "Comments box missing"

      textArea.val("Bravo!").change().trigger(event)

      comments = $('.comments', commentsContainer)
      condition = -> comments.length == 2

      waitForSelector ".comment-text", (coms)->
        assertText coms, "Bravo!"
