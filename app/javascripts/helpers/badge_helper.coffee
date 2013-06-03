Ember.Handlebars.registerBoundHelper 'badge', (value, options) ->
  return if value == undefined

  formatted = Handlebars.Utils.escapeExpression value

  style = "badge-#{options.hash.style}" if options.hash.style

  new Handlebars.SafeString "<span class='badge #{style}'>#{formatted}</span>"
