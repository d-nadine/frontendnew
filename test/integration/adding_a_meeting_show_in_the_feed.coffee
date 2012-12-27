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
