Ember.Handlebars.registerBoundHelper 'thirdpartyIcon', (model, options) ->
  availableIcons = ['intercom', 'gmail', 'olark', 'hubspot', 'wufoo', 'twitter', 'radium']

  icon = if availableIcons.contains(@get('source'))
           @get('source')
         else
           "zapier"

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
               else if style == 'icon'
                 {height: 16, width: 16}
               else
                 {height: 32, width: 32}

  props.crop = 'fill'
  props.gravity = 'face'

  img = $.cloudinary.image("thirdparty/#{icon}.png", props)

  return new Handlebars.SafeString(img.get(0).outerHTML)
