Ember.Handlebars.registerBoundHelper 'format', (value, options) ->
  format = options.hash.format

  Ember.assert "Cannot use the format helper without a format option", format

  formatted = Handlebars.Utils.escapeExpression value.toFormattedString format
  new Handlebars.SafeString "<time>#{formatted}</time>"
