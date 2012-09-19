test 'feed sections with dates should be displayed', ->
  app '/', ->
    section = F.feed_sections('default')
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    todo = F.todos('default')

    waitForResource todo, ->
      headers = $('#feed .page-header h3')
      assertContains headers, 'Friday, August 17, 2012.*Tuesday, August 14, 2012'

test 'feed sections should contain todo items', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    todo = F.todos('default')

    waitForResource todo, (el) ->
      assertContains el, 'Finish first product draft'

test 'when scrolling back, feed loads older items', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    controller = Radium.get('router.feedController')

    waitFor (-> controller.get('length') > 0 ), ->
      assertContains 'Friday, August 17, 2012.*Tuesday, August 14, 2012'
      assertNotContains 'Sunday, July 15, 2012'

      equal $('#mini-loader').css('display'), 'none', 'loader should be hidden before loading'

      Ember.run ->
        controller.loadFeed back: true

      waitFor (-> $('#mini-loader').css('display') == 'block' ), (-> ), 'loader should be visible while loading'

      section = F.feed_sections('feed_section_2012_07_15')
      waitForResource section, ->
        assertContains 'Sunday, July 15, 2012'
        waitFor (-> $('#mini-loader').css('display') == 'none' ), ->
          ok true, 'loader should be hidden after data is loaded'

test 'when scrolling forward, feed loads newer items', ->
  expect 2

  app '/', ->
    section = F.feed_sections 'feed_section_2012_07_15'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    waitForResource section, ->
      assertNotContains 'Tuesday, August 14, 2012'

      controller = Radium.get('router.feedController')
      controller.loadFeed forward: true

      section = F.feed_sections('default')
      waitFor (-> $('#main-feed').text().match(/Tuesday, August 14, 2012/) ), ->
        assertContains 'Tuesday, August 14, 2012'
