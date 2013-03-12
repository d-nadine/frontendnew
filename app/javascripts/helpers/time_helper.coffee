formats = {
  full: "%B %d, %Y %i:%M %p"
  short: "%i:%M%p"
  date: "%B, %D %Y"
}

Ember.Handlebars.registerBoundHelper 'time', (value, options) ->
  return unless value

  options.hash.format ||= 'short'
  format = formats[options.hash.format]

  formatted = Handlebars.Utils.escapeExpression value.toFormattedString(format)

  if options.hash.class
    new Handlebars.SafeString "<time class=\"time #{options.hash.class}\">#{formatted}</time>"
  else
    new Handlebars.SafeString "<time>#{formatted}</time>"
