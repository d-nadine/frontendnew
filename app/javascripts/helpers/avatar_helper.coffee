Ember.Handlebars.registerBoundHelper 'avatar', (person, options) ->
  style = options.hash.style || 'small'

  avatar = person.get('avatar') || {}

  url = avatar["#{style}_url"] || "/images/default_avatars/#{style}.png"

  title = person.get 'name'

  new Handlebars.SafeString("<img src='#{url}' title='#{title}' class='avatar avatar-#{style} #{options.hash.class}'/>")
