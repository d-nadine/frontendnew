test 'gap element is shown when there is a gap', ->
  Ember.run ->
    Radium.get('router').transitionTo('root.dashboard')

  section = F.feed_sections 'default'
  item    = F.todos 'default'
  month_from_now_section = F.feed_sections 'month_from_now'

  waitForResource section, ->
    addTodo item, month_from_now_section, ->

      # need to wait for store, gap items are not available through FIXTURES
      wait 100, ->
        nextSection = F.feed_sections 'section_2012_08_31'

        assertContains "5 days are not loaded"
        ok !$(nextSection.get('domClass')).length, 'next section is not loaded'

        $('.gap').click()
        waitForResource nextSection, ->
          ok true
