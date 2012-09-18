test 'calendar feed displays only deals, todos and meetings and disables clustering', ->
  app '/calendar', ->
    section = F.feed_sections 'default'

    Ember.run ->
      Radium.router.send 'showDate', date: section.get('id')

    waitForResource section, (el) ->
      assertResource F.todos('default')
      assertResource F.meetings('default')
      assertResource F.deals('default')
      assertNoResource F.call_lists('default')

      equal $('.cluster-item').length, 0, 'there should be no clusters'

test 'changing date on calendar changes date also on meeting form', ->
  app '/calendar', ->
    waitForSelector '.calendar', (el) ->
      today = Ember.DateTime.create()
      startDate = $('#start-date').val()
      equal startDate, today.toFormattedString('%Y-%m-%d'), 'meeting form should be set to today by default'

      tomorrow = today.advance(day: 1)

      $(".day-#{tomorrow.get('day')}").click()

      waitFor (-> $('#start-date').val() != startDate ), ->
        tomorrow = tomorrow.toFormattedString('%Y-%m-%d')
        equal $('#start-date').val(), tomorrow, 'meeting should change date'
        equal window.location.href, "http://localhost:7777/calendar/#{tomorrow}"

test 'changing date on meeting form changes also date on calendar', ->
  app '/calendar', ->
    waitForSelector '#start-date', (el) ->
      today = Ember.DateTime.create()
      startDate = $('#start-date').val()
      equal startDate, today.toFormattedString('%Y-%m-%d'), 'meeting form should be set to today by default'
      ok $(".calendar .day-#{today.get('day')}").hasClass('active'), 'calendar should be set for today'

      weekFromNow = today.advance(day: 7)

      fillIn '#start-date', weekFromNow.toFormattedString('%Y-%m-%d')

      waitFor (-> $(".calendar .day-#{weekFromNow.get('day')}").hasClass('active') ), ->
        weekFromNow = weekFromNow.toFormattedString('%Y-%m-%d')
        equal window.location.href, "http://localhost:7777/calendar/#{weekFromNow}"
