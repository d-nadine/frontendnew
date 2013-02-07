Ember.Handlebars.registerHelper 'renderMailPanel', (contextString, options) ->
  # FIXME: duplication of sidebar_item_view
  templateMap =
    'Radium.Email': 'email'
    'Radium.Discussion': 'discussion'

  context = Ember.Handlebars.get(options.contexts[0], contextString, options)

  options.contexts.push(context)

  templateName = "messages/#{templateMap[context.constructor]}_panel"

  Ember.Handlebars.helpers.render.call(this, templateName, contextString, options)


