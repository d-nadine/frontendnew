Ember.Handlebars.registerBoundHelper 'badge', (value, options) ->
  return unless value

  formatted = Handlebars.Utils.escapeExpression value

  style = "badge-#{options.hash.style}" if options.hash.style

  new Handlebars.SafeString "<span class='badge #{style}'>#{formatted}</span>"
