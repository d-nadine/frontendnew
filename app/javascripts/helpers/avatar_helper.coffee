Ember.Handlebars.registerBoundHelper 'avatar', (person, options) ->
  style = options.hash.style || options.hash.size || 'small'

  unless person && person.get('avatarKey')
    if style == 'dashboard'
      style = 'huge'

    url = "/images/default_avatars/#{style}.png"

    return new Handlebars.SafeString("<img src='#{url}' class='avatar avatar-#{style} #{options.hash.class}'/>")

  dimensions = if style == 'large'
                 {height: 124, width: 124}
               else if style == 'medium'
                 {height: 64, width: 64}
               else if style == 'dashboard'
                 {height: 244, width: 244}
               else
                 {height: 32, width: 32}

  url = "http://res.cloudinary.com/radium/image/upload/h_#{dimensions.height},w_#{dimensions.width},c_fill,g_face/#{person.get('avatarKey')}.jpg"

  return new Handlebars.SafeString("<img src='#{url}' class='avatar #{options.hash.class}'/>")
