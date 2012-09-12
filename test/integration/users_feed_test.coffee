test 'users feed displays only users', ->
  app '/users/1', ->
    todo = F.todos('default')

    waitForResource todo, (el) ->
      assertContains 'Finish first product draft'
      assertNotContains 'Prepare product presentation'
