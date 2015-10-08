formats = {
  full: "%B %d, %Y %i:%M %p"
  short: "%i:%M %p"
  date: "%B, %D %Y"
  monthYear: "%B %Y"
  calendar: "%A, %B %D %Y"
  brief: "%D %b %y"
}

Ember.Handlebars.registerBoundHelper 'formatDateTime', (value, options) ->
  return unless value

  options.hash.format ||= 'short'
  format = formats[options.hash.format]

  if Ember.DateTime.detectInstance value
    date = value.toFormattedString(format)
  else
    date = Ember.DateTime.create(value.getTime()).toFormattedString(format)
  formatted = Handlebars.Utils.escapeExpression(date)

  if options.hash.class
    new Handlebars.SafeString "<time class=\"time #{options.hash.class}\">#{formatted}</time>"
  else
    new Handlebars.SafeString "<time>#{formatted}</time>"
