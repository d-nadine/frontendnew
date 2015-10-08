Ember.Handlebars.registerBoundHelper 'label', (value, options) ->
  return unless value
  formatted = Handlebars.Utils.escapeExpression value
  new Handlebars.SafeString "<span class='label'>#{formatted}</span>"
