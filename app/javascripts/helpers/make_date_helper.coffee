Ember.Handlebars.registerHelper 'makeDate', (unit, period, options) ->
  forward = {}
  if period == "week"
    forward["day"] = (unit * 7)
  else
    forward[period] = unit
  Ember.DateTime.create().advance(forward)
