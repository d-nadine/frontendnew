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

feedSelector = null

module 'integration - feed'
  setup: ->
    section = Factory.create 'feed_section'
    meeting = Factory.create 'meeting'
    todo = Factory.create 'todo',
            description: 'Todo assertion'

    Ember.run ->
      Radium.get('router.feedController').pushItem meeting
      Radium.get('router.feedController').pushItem todo

    feedSelector = ".feed_section_#{section.get('id')}"

test 'meeting and todo can appear in the feed', ->
  equal Radium.FeedSection.find().get('length'), 1, 'precond - there is 1 feed item'

  waitForSelector feedSelector, (el) ->
    assertContains el, 'Product discussion'
    assertContains el, 'Todo assertion'
