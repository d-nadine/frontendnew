test 'groups feed displays only groups', ->
  app '/groups/1', ->
    todo = F.todos('group')

    waitForResource todo, (el) ->
      assertContains 'schedule group meeting'
      assertNotContains 'Prepare product presentation'
