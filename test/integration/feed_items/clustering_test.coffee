test 'clustering feed items', ->
  section = F.feed_sections('default')

  waitForResource section, (el) ->
    assertNotContains el, 'Finish first product draft'

    cluster = $('.cluster-item', el)
    cluster.click()

    todo = F.todos('default')

    waitForResource todo, (el) ->
      assertContains el, 'Finish first product draft'
