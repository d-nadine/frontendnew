Ember.Handlebars.registerBoundHelper 'showWarningIfEmpty', (value, options) ->
  return value unless Ember.isEmpty(value)

  new Handlebars.SafeString("<i class='icon-warning-sign'></i>")
