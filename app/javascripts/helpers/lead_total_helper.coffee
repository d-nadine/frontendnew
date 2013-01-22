Ember.Handlebars.registerHelper 'leadTotal', (property, options) ->
  value = Ember.get(this, property)

  options.data.view.get("controller.#{value}Total")
