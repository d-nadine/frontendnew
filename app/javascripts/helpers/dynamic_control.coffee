Ember.Handlebars.registerHelper("dynamicControl", (path, modelPath, options) ->
  path = Ember.Handlebars.get(this, path)

  Ember.Handlebars.helpers.control.call(this, path, modelPath, options)
)
