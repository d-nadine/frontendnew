Ember.Handlebars.registerBoundHelper 'truncate', (value, options) ->
  length = options.hash.length || 25

  if value.length >= length
    Handlebars.Utils.escapeExpression "#{value.slice(0, length-3)}..."
  else
    Handlebars.Utils.escapeExpression(value.slice(0, length))
