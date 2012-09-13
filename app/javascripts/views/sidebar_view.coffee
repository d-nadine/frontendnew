Radium.SidebarView = Em.View.extend
  templateName: 'sidebar'

  setDailyRange: ->
    Radium.get('router.feedController').set('range', 'daily')
  setWeeklyRange: ->
    Radium.get('router.feedController').set('range', 'weekly')
  setMonthlyRange: ->
    Radium.get('router.feedController').set('range', 'monthly')
