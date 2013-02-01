Ember.Handlebars.registerBoundHelper 'date', (value, options) ->
  return unless value
  formatted = Handlebars.Utils.escapeExpression value.toFormattedString("%B, %D %Y")
  new Handlebars.SafeString "<time>#{formatted}</time>"
