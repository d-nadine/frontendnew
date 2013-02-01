Ember.Handlebars.registerBoundHelper 'time', (value, options) ->
  return unless value
  formatted = Handlebars.Utils.escapeExpression value.toFormattedString("%i:%M")
  new Handlebars.SafeString "<time>#{formatted}</time>"
