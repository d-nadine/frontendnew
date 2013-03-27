Ember.Handlebars.registerBoundHelper 'capitalize', (value, options) ->
  return if !value

  value.capitalize()
