Radium.RangeChangerView = Em.View.extend
  templateName: 'range_changer'

  setDailyRange: ->
    Radium.get('currentFeedController').set('range', 'daily')
  setWeeklyRange: ->
    Radium.get('currentFeedController').set('range', 'weekly')
  setMonthlyRange: ->
    Radium.get('currentFeedController').set('range', 'monthly')
