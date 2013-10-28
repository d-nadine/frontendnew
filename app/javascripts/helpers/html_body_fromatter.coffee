Ember.Handlebars.registerBoundHelper 'htmlBodyFormatter', (message, options) ->
  return new Handlebars.SafeString("<p>(No Message)</p>") unless message?.length

  text = @get('html')
  re = /^x-msg:\/\//ig
  text = text.replace(re,"#")
  text = text.replace(/<BASE[^>]*>/g,"")

  return new Handlebars.SafeString("#{text}")
