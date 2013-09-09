Ember.Handlebars.registerBoundHelper 'avatar', (person, options) ->
  style = options.hash.style || options.hash.size || 'small'

  unless person.get('avatarKey')
    url = "/images/default_avatars/#{style}.png"

    return new Handlebars.SafeString("<img src='#{url}' class='avatar avatar-#{style} #{options.hash.class}'/>")

  dimensions = if style == 'large'
                 {height: 124, width: 124}
              else if style == 'medium'
                 {height: 64, width: 64}
              else
                 {height: 32, width: 32}

  url = "http://res.cloudinary.com/radium/image/upload/c_fit,h_#{dimensions.height},w_#{dimensions.width}/#{person.get('avatarKey')}.jpg"

  return new Handlebars.SafeString("<img src='#{url}' class='avatar #{options.hash.class}'/>")
