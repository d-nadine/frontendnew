Ember.Handlebars.registerBoundHelper 'ageInWords', (value, options) ->
  return "Never" unless value

  now = Ember.DateTime.create()

  days = value.daysApart now

  text = if days == 0
    "New"
  else if days == 1
    "1 day"
  else
    "#{days} days"

  html = "<time>#{text}</time>"

  new Handlebars.SafeString html
