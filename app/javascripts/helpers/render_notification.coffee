Ember.Handlebars.registerBoundHelper 'renderNotification', (notification, options) ->
  template = "notifications/#{notification.get('event')}/#{notification.get('tag')}"
  options.contexts[1] = options.contexts[0]
  Ember.Handlebars.helpers.render.call(this, template, 'model', options)
