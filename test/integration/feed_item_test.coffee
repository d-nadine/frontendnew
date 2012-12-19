module 'Integration - Feed'

test 'adding a meeting shows it in the feed', ->
  expect(3)

  Radium.reset()

  assertEmptyFeed()

  waitForSelector '.filters .add-meeting', (el) ->
    el.click()

    waitForSelector '#form-container', (el) ->
      meetingDate = Ember.DateTime.create().advance(days: 7)

      fillIn '#start-date', meetingDate.toDateFormat()
      fillIn '#description', 'New meeting'

      $('.btn-success').click()

      feedSelector = ".feed_section_#{meetingDate.toDateFormat()}"

      waitForSelector feedSelector, (el) ->
        assertFeedItems(1)
        assertText el, 'New meeting'

test 'todos appear in the feed', ->
  expect(3)

  Radium.reset()

  assertEmptyFeed()

  section = Factory.create 'feed_section'
  todo = Factory.create 'todo',
          description: 'Finish programming radium'

  Ember.run ->
    Radium.get('router.feedController').pushItem todo

  feedSelector = ".feed_section_#{section.get('id')}"

  assertFeedItems 1

  waitForSelector feedSelector, (el) ->
    assertText el, 'Finish programming radium'
