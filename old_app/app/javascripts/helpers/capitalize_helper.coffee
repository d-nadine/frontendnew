Ember.Handlebars.registerBoundHelper 'capitalize', (value) ->
  return value.capitalize() if value?.length
