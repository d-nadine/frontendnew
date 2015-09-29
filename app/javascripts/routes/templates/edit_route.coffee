require 'mixins/controllers/save_email_mixin'
require 'mixins/templates_fields_promise'

Radium.TemplatesEditRoute = Ember.Route.extend Radium.SaveEmailMixin,
  Radium.TemplatesFieldsPromise,

  templateForm: Radium.TemplateForm.create()

  beforeModel: (transition) ->
    @templatesFiledsPromise("templatesEdit")

  afterModel: (model, transition) ->
    form = @templateForm

    form.reset(false)

    form.setProperties
      id: model.get('id')
      reference: model
      subject: model.get('subject')
      html: model.get('html')
      files: model.get('attachments').map (attachment) -> Ember.Object.create(attachment: attachment)
      bucket: model.get('bucket')

    @controllerFor('templatesEdit').set('form', form)
