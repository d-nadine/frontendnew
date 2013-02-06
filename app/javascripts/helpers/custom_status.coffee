Ember.Handlebars.registerHelper 'statusItemClass', (value, options) ->
  index = Ember.get(this, value)

  if index % 2 == 0
    "lost"
  else
    "negotiating"
