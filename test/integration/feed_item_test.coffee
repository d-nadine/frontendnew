module 'Integration - Feed'

test 'adding a meeting shows it in the feed', ->
  expect(3)

  assertEmptyFeed()

  waitForSelector '.filters .add-meeting', (el) ->
    el.click()

    waitForSelector '#form-container', (el) ->
      meetingDate = Ember.DateTime.create().advance(day: 7)

      fillIn '#start-date', meetingDate.toDateFormat()
      fillIn '#description', 'New meeting'

      $('.btn-success').click()

      feedSelector = ".feed_section_#{meetingDate.toDateFormat()}"

      waitForSelector feedSelector, (el) ->
        assertFeedItems(1)
        assertText el, 'New meeting'

test 'todos appear in the feed', ->
  expect(3)

  assertEmptyFeed()

  section = $W.Factory.create 'feed_section'
  todo = $W.Factory.create 'todo',
          description: 'Finish programming radium'

  $W.Ember.run ->
    $A.get('router.feedController').pushItem todo

  feedSelector = ".feed_section_#{section.get('id')}"

  waitForSelector feedSelector, (el) ->
    assertFeedItems 1
    assertText el, 'Finish programming radium'
