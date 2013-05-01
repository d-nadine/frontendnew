Ember.Handlebars.registerHelper "renderActivity", (modelPath, options) ->
  activity = Ember.Handlebars.get this, modelPath, options
  templateName = "activities/#{activity.get('tag')}"

  Ember.Handlebars.helpers.render.call this, templateName, modelPath, options
