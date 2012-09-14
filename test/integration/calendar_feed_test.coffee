test 'calendar feed displays only deals, todos and meetings and disables clustering', ->
  app '/calendar', ->
    section = F.feed_sections 'default'

    waitForResource section, (el) ->
      assertResource F.todos('default')
      assertResource F.meetings('default')
      assertResource F.deals('default')
      assertNoResource F.call_lists('default')

      equal $('.cluster-item').length, 0, ''
