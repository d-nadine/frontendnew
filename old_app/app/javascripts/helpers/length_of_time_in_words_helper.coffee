Ember.Handlebars.registerBoundHelper 'lengthOfTimeInWords', (value, options) ->
  if value < 60
    new Handlebars.SafeString "less than a minute"
  else if value < 60 * 60
    new Handlebars.SafeString "#{Math.floor(value / 60)} minute(s)"
  else
    new Handlebars.SafeString "#{Math.floor(value / (60 * 60))} hour(s)"
