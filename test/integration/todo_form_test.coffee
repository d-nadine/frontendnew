test 'todo can be added', ->

  Ember.run ->
    Radium.get('router').transitionTo('root.dashboard')

  section = F.feed_sections('default')
  todo = F.todos('default')

  waitForResource todo, (el) ->
    el.click()

    waitForSelector ['.add-todo', el], (el) ->
      el.click()

      waitForSelector '.radium-form', (el) ->
        $('#finish-by-date', el).val('2012-09-01')

        event = jQuery.Event("keypress")
        event.keyCode = 13
        $('#description', el).val('New todo').trigger(event)

        wait 100, ->
          controller = Radium.get('router.feedController')
          controller.loadFeed forward: true

          waitForResource Radium.store.find(Radium.FeedSection, '2012-09-01'), (el) ->
            assertContains el, 'Saturday, September 1, 2012'
