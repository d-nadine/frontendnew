test 'contacts feed displays only contacts', ->
  app '/contacts/1', ->
    todo = F.todos('call')

    waitForResource todo, (el) ->
      assertContains 'Call Ralph for discussing offer details'
      assertNotContains 'Finish first product draft'
