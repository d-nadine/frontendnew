module 'Integration - Feed'

test 'adding a meeting shows it in the feed', ->
  document.getElementById('app').onload = ->
    window.$F = document.getElementById('app').contentWindow.jQuery
    window.$A = document.getElementById('app').contentWindow.Radium
    window.$W = document.getElementById('app').contentWindow

    $A.ready = ->
      expect(3)

      assertEmptyFeed()

      waitForSelector '.filters .add-meeting', (el) ->
        el.click()

        waitForSelector '#form-container', (el) ->
          meetingDate = Ember.DateTime.create().advance(day: 7)

          fillIn '#start-date', meetingDate.toDateFormat()
          fillIn '#description', 'New meeting'

          $F('.btn-success').click()

          feedSelector = ".feed_section_#{meetingDate.toDateFormat()}"

          waitForSelector feedSelector, (el) ->
            assertFeedItems(1)
            assertText el, 'New meeting'

      start()

  stop()

  $W.location.reload()

test 'todos appear in the feed', ->
  document.getElementById('app').onload = ->
    window.$F = document.getElementById('app').contentWindow.jQuery
    window.$A = document.getElementById('app').contentWindow.Radium
    window.$W = document.getElementById('app').contentWindow

    $A.ready = ->
      expect(3)

      assertEmptyFeed()

      section = $W.Factory.create 'feed_section'
      todo = $W.Factory.create 'todo',
              description: 'Finish programming radium'

      $W.Ember.run ->
        console.log $A.get('router')
        $A.get('router.feedController').pushItem todo

      feedSelector = ".feed_section_#{section.get('id')}"

      waitForSelector feedSelector, (el) ->
        assertFeedItems 1
        assertText el, 'Finish programming radium'

      start()

  stop()

  $W.location.reload()

