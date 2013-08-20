Ember.Handlebars.registerBoundHelper 'renderActivity', (activity, options) ->
  template = "activities/#{activity.get('tag')}"
  # FIXME: no idea why we have to do this
  options.contexts[1] = options.contexts[0]
  Ember.Handlebars.helpers.render.call(this, template, 'model', options)

