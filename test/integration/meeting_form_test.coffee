test 'meeting can be added', ->
  app '/', ->
    waitForSelector '.filters .add-meeting', (el) ->
      el.click()

      waitForSelector '#form-container', (el) ->
        tomorrow = F.feed_sections('tomorrow')

        fillIn '#start-date', tomorrow.get('id')
        fillIn '#description', 'New meeting'
        $('.btn-success').click()

        waitForResource tomorrow, (el) ->
          assertContains el, 'New meeting'
