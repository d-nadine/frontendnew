Ember.Handlebars.registerBoundHelper 'avatar', (person, options) ->
  style = options.hash.style || options.hash.size || 'small'

  # FIXME: implement avatars
  url = "/images/default_avatars/#{style}.png"

  new Handlebars.SafeString("<img src='#{url}' class='avatar avatar-#{style} #{options.hash.class}'/>")
