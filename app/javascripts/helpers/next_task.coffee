Ember.Handlebars.registerHelper 'nextTask', (property, options) ->
  if value = Ember.get(this, property)
    return value

  new Handlebars.SafeString("<i class='icon-warning-sign'></i>")
