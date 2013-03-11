Ember.Handlebars.registerBoundHelper 'time', (value, options) ->
  return unless value

  formatted = Handlebars.Utils.escapeExpression value.toFormattedString("%i:%M%p")

  if options.hash.class
    new Handlebars.SafeString "<time class=\"time #{options.hash.class}\">#{formatted}</time>"
  else
    new Handlebars.SafeString "<time>#{formatted}</time>"
