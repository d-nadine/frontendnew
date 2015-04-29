Radium.TemplatesNewRoute = Ember.Route.extend
  templateForm: Radium.TemplateForm.create()

  beforeModel: (transition) ->
    @controllerFor('templatesNew').set 'customFields', Radium.CustomField.find({})

  model: ->
    model = @templateForm

    model.reset()

    model
