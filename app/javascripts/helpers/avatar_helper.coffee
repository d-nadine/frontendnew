Ember.Handlebars.registerBoundHelper 'avatar', (resource, options) ->
  style = options.hash.style || options.hash.size || 'small'

  props = if style == 'dashboard'
            {height: 244, width: 244}
          else if style == 'large'
            {height: 124, width: 124}
          else if style == 'sidebar'
            {height: 72, width: 72}
          else if style == 'medium'
            {height: 64, width: 64}
          else if style == 'contacts-table'
            {height: 32, width: 32}
          else if style == 'small'
            {height: 30, width: 30}
          else if style == 'tiny'
            {height: 22, width: 22}
          else
            {height: 32, width: 32}

  props.crop = 'fill'
  props.gravity = 'face'

  avatar = if resource && resource.get('avatarKey')
             resource.get('avatarKey')
           else
             if resource && resource.constructor is Radium.Company
               "default_avatars/company"
             else
               "default_avatars/large"

  img = $.cloudinary.image("#{avatar}.jpg", props)

  return new Handlebars.SafeString(img.get(0).outerHTML)
