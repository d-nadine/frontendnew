require 'mixins/controllers/save_email_mixin'
require 'mixins/templates_fields_promise'

Radium.TemplatesNewRoute = Ember.Route.extend Radium.SaveEmailMixin,
  Radium.TemplatesFieldsPromise,

  templateForm: Radium.TemplateForm.create()

  beforeModel: (transition) ->
    @templatesFiledsPromise("templatesNew")

  model: ->
    model = @templateForm

    model.reset()

    model
