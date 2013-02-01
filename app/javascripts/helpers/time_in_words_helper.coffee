Ember.Handlebars.registerBoundHelper 'timeInWords', (value, options) ->
  return "Never" unless value

  now = Ember.DateTime.create()
  timeDiff = now.get('milliseconds') - value.get('milliseconds')
  Math.ceil(timeDiff / (1000 * 3600 * 24))

  days = value.daysApart Ember.DateTime.create()

  text = if days == 0
    "Today"
  else if days == 1
    "Tomorrow"
  else if days == -1
    "Yesterday"
  else if days > 1
    "#{days} days from now"
  else if days < 1
    "#{days} days ago"

  className = if days == 0
    "today"
  else if days < 0
    "past"
  else if
    "future"

  html = '<time class="time-in-words %@">%@</time>'.fmt className, text
  new Handlebars.SafeString html
