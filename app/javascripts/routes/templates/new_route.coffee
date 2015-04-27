Radium.TemplatesNewRoute = Ember.Route.extend
  templateForm: Radium.TemplateForm.create()

  model: ->
    model = @templateForm

    model.reset()

    model
