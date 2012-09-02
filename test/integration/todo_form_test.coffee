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
        tomorrow = F.feed_sections('tomorrow')

        Ember.run ->
          $('.more-options', el).click()

        # keyup with any char to trigger bindings sync
        event = jQuery.Event("keyup")
        event.keyCode = 46
        $('#finish-by-date').val(tomorrow.get('id')).trigger(event)

        event = jQuery.Event("keyup")
        event.keyCode = 46
        $('#description').val('New todo').trigger(event)

        event = jQuery.Event("keypress")
        event.keyCode = 13
        $('#description').trigger(event)

        waitForResource tomorrow, (el) ->
          assertContains el, 'New todo'
