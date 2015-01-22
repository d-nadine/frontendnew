Ember.Handlebars.registerBoundHelper 'avatar', (person, options) ->
  style = options.hash.style || options.hash.size || 'small'

  props = if style == 'large'
            {height: 124, width: 124}
          else if style == 'medium'
            {height: 64, width: 64}
          else if style == 'small'
            {height: 30, width: 30}
          else if style == 'dashboard'
            {height: 244, width: 244}
          else if style == 'tiny'
            {height: 22, width: 22}
          else
            {height: 32, width: 32}

  props.crop = 'fill'
  props.gravity = 'face'

  avatar = if person && person.get('avatarKey')
             person.get('avatarKey')
           else
             "default_avatars/large"

  img = $.cloudinary.image("#{avatar}.jpg", props)

  return new Handlebars.SafeString(img.get(0).outerHTML)
