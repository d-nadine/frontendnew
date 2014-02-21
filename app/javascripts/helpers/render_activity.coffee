Ember.Handlebars.registerBoundHelper 'renderActivity', (options) ->
  template = "activities/#{@get('tag')}"
  options.contexts[1] = options.contexts[0]
  Ember.Handlebars.helpers.render.call(this, template, 'model', options)

