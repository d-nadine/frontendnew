Ember.Handlebars.registerBoundHelper 'htmlBodyFormatter', (message, options) ->
  return new Handlebars.SafeString("<p>(No Message)</p>") unless message?.length

  text = @get('html')
  text = text.replace(/(href=")x-msg:\/\/([^"]+)\//ig, '$1#$2')

  return new Handlebars.SafeString("#{text}")
