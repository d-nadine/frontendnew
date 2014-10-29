Radium.DefaultAvatars =
  small: "small_cj96pu"
  medium: "medium_m7scj1"
  large: "large_hpaznc"
  huge: "huge_tacjys"

Radium.cloudinaryUrl = "http://res.cloudinary.com/radium/image/upload/"

Ember.Handlebars.registerBoundHelper 'avatar', (person, options) ->
  style = options.hash.style || options.hash.size || 'small'

  dimensions = if style == 'large'
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

  avatar = if person && person.get('avatarKey')
             person.get('avatarKey')
           else
             Radium.DefaultAvatars["large"]

  url = "#{Radium.cloudinaryUrl}h_#{dimensions.height},w_#{dimensions.width},c_fill,g_face/#{avatar}.jpg"

  return new Handlebars.SafeString("<img src='#{url}' class='avatar #{options.hash.class}'/>")
