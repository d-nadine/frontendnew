test 'feed can be filtered', ->
  Ember.run ->
    Radium.get('router').transitionTo('root.dashboard')

  section = F.feed_sections('default')

  waitForResource section, (el) ->
    assertContains 'Call list'
    assertContains 'Great deal'
    assertContains '6 todos'

    dealFilter = $('.filters li a').toArray().find (e) ->
      $(e).text().match(/Deals/)

    $(dealFilter).click()

    waitFor (-> !$('#main-feed').text().match(/Call list/) ), ->
      assertNotContains 'Call list'
      assertNotContains '6 todos'
      waitFor (-> $('#main-feed').text().match(/Great deal/) ), ->
        assertContains 'Great deal'

