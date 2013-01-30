Ember.Handlebars.registerHelper 'avatar', (property, options) ->
  defaultSrc = '/images/fallback/small_default.png'

  value = Ember.get(this, 'avatar')

  return "" unless value

  src = if value = Ember.get(this, 'avatar')
          if small_url = value.small_url
            small_url
          else
            defaultSrc

  title = Ember.get(this, 'displayName') || ""

  new Handlebars.SafeString("<img src='#{src}' title='#{title}' class='avatar'/>")
