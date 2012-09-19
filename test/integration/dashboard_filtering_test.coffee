test 'feed can be filtered', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    item = F.call_lists('default')

    waitForResource item, ->
      ok $('.filters li.all').hasClass('active'), 'initially "Everything" filter is selected'
      assertContains 'Call list'
      assertContains 'Great deal'
      assertContains '6 todos'

      dealFilter = $('.filters li.deal a')

      $(dealFilter).click()

      waitFor (-> !$('#main-feed').text().match(/Call list/) ), ->
        assertNotContains 'Call list'
        assertNotContains '6 todos'
        waitFor (-> $('#main-feed').text().match(/Great deal/) ), ->
          ok $('.filters li.deal').hasClass('active'), 'filter has active class'
          assertContains 'Great deal'

test 'loading new items for the feed that should be hidden triggers showing "filtered info view" ', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    item = F.call_lists('default')
    waitForResource item, (el) ->
      $('.filters li.todo a').click()

      waitFor (-> !$('#main-feed').text().match(/Call list/) ), ->

        controller = Radium.get('router.feedController')

        Ember.run ->
          controller.loadFeed forward: true

        waitFor (-> $('#main-feed').text().match(/New items are loaded/) ), ->
          assertContains 'Filtered 1 item'

          Ember.run ->
            controller.loadFeed forward: true

          waitFor (-> $('#main-feed').text().match(/Filtered 2 items/) ), ->
            assertContains 'Filtered 2 items'

test 'loading new items backwards that should be hidden triggers showing "filtered info view" ', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    item = F.call_lists('default')
    waitForResource item, (el) ->
      $('.filters li.todo a').click()

      waitFor (-> !$('#main-feed').text().match(/Call list/) ), ->

        controller = Radium.get('router.feedController')

        Ember.run ->
          controller.loadFeed back: true

        waitFor (-> $('#main-feed').text().match(/New items are loaded/) ), ->
          assertContains 'Filtered 1 item'

          Ember.run ->
            controller.loadFeed back: true

          assertContains 'Filtered 2 items'

test 'adding an item to filtered area should split the area', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    item = F.todos('default')
    waitForResource item, (el) ->
      $('.filters li.todo a').click()

      wait 100, ->
        controller = Radium.get('router.feedController')
        content = controller.get('content')

        content.loadRecord F.feed_sections('section_2012_08_31')
        content.loadRecord F.feed_sections('today')
        content.loadRecord F.feed_sections('tomorrow')
        content.loadRecord F.feed_sections('week_from_now')
        content.loadRecord F.feed_sections('two_weeks_from_now')
        content.loadRecord F.feed_sections('month_from_now')

        waitFor (-> $('#main-feed').text().match(/New items are loaded/) ), ->
          assertContains 'Filtered 6 items'

          section = F.feed_sections('tomorrow')
          addTodo item, section, {description: 'Nice!'}, ->
            waitFor (-> $('body').text().match(/Nice/) ), ->
              assertContains 'Filtered 3 items.*Filtered 2 items'
