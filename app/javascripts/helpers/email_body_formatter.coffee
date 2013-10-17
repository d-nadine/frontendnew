Ember.Handlebars.registerBoundHelper 'emailBodyFormatter', (message, options) ->
  return new Handlebars.SafeString("<p>(No Message)</p>") unless message?.length

  text = @get('message').replace(/\n/g, '<br />')
  re = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
  text = text.replace(re,"<a href='$1' target='_new'>$1</a>")
  text = text.replace(/<img[^>]*>/g,"")

  return new Handlebars.SafeString("<p>#{text}</p>")
