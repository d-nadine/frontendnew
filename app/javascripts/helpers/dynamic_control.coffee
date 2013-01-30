Ember.Handlebars.registerHelper("dynamicControl", (path, modelPath, options) ->
  path = Ember.Handlebars.get(this, path)
  console.log path
  Ember.Handlebars.helpers.control.call(path, modelPath, options)
)
