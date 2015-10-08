Ember.Handlebars.registerBoundHelper 'renderNotification', (notification, options) ->
  template = "notifications/#{@get('event')}/#{@get('tag')}"
  options.contexts[1] = options.contexts[0]
  options.types[0] = "STRING"
  Ember.Handlebars.helpers.render.call(this, template, 'model', options)
