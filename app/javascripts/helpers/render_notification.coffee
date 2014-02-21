Ember.Handlebars.registerBoundHelper 'renderNotification', (options) ->
  template = "notifications/#{@get('event')}/#{@get('tag')}"
  options.contexts[1] = options.contexts[0]
  Ember.Handlebars.helpers.render.call(this, template, 'model', options)
