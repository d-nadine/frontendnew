require 'mixins/controllers/save_email_mixin'

Radium.TemplatesNewRoute = Ember.Route.extend Radium.SaveEmailMixin,
  templateForm: Radium.TemplateForm.create()

  beforeModel: (transition) ->
    new Ember.RSVP.Promise (resolve, reject) =>
      Radium.CustomField.find({}).then((fields) =>
        @controllerFor('templatesNew').set 'customFields', fields
        resolve()
      ).catch (error) ->
        reject(error)

  model: ->
    model = @templateForm

    model.reset()

    model
