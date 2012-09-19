test 'clustering feed items', ->
  app '/', ->
    section = F.feed_sections 'default'
    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    waitForResource section, (el) ->
      assertNotContains el, 'Finish first product draft'
      assertContains el, '6 todos'

      cluster = $('.cluster-item', el)
      cluster.click()

      todo = F.todos('default')

      waitForResource todo, (el) ->
        assertContains el, 'Finish first product draft'
