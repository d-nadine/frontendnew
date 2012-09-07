test 'user should be able to load any date for feed', ->
  expect(3)
  app '/', ->

    section = F.feed_sections('default')

    waitForResource section, ->
      assertContains 'Friday, August 17, 2012'

      Radium.get('router').transitionTo('dashboardWithDate', date: '2012-07-14')

      section = F.feed_sections('feed_section_4')
      waitForResource section, ->
        assertContains 'Sunday, July 15, 2012'
        assertNotContains 'Friday, August 17, 2012'
