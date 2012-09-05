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

        fillIn '#finish-by-date', tomorrow.get('id')
        fillIn '#description', 'New todo'
        enterNewLine('#description')

        waitForResource tomorrow, (el) ->
          assertContains el, 'New todo'

test 'todo is showed only once', ->

  Ember.run ->
    Radium.get('router').transitionTo('root.dashboard')

  section = F.feed_sections('tomorrow')
  todo = F.todos('call')

  addTodo todo, section, { description: 'Nice todo' }, (sectionElement) ->
    assertContains sectionElement, 'Nice todo'
    assertNotContains sectionElement, 'Nice todo.*Nice todo'
