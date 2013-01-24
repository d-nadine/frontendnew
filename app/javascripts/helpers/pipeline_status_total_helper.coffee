Ember.Handlebars.registerHelper 'pipelineStatusTotal', (property, options) ->
  value = Ember.get(this, property)

  options.data.view.get("parentView.status.#{value}Total")
