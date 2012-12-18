module 'integration - feed - Empty feed'

test 'create a meeting and it appears in a feed with no feed sections', ->
  waitForSelector '.filters .add-meeting', (el) ->
    el.click()

    waitForSelector '#form-container', (el) ->
      meetingDate = Ember.DateTime.create()

      fillIn '#start-date', meetingDate.toDateFormat()
      fillIn '#description', 'New meeting'

      $('.btn-success').click()

      newFeedSectionSelector = ".feed_section_#{meetingDate.toDateFormat()}"

      waitForSelector newFeedSectionSelector, (el) ->
        assertContains el, 'New meeting'
