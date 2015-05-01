require 'mixins/controllers/save_email_mixin'

Radium.TemplatesEditRoute = Ember.Route.extend Radium.SaveEmailMixin,
  templateForm: Radium.TemplateForm.create()

  beforeModel: (transition) ->
    new Ember.RSVP.Promise (resolve, reject) =>
      Radium.CustomField.find({}).then((fields) =>
        @controllerFor('templatesEdit').set 'customFields', fields
        resolve()
      ).catch (error) ->
        reject(error)

  afterModel: (model, transition) ->
    form = @templateForm

    form.reset()

    form.setProperties
      id: model.get('id')
      reference: model
      subject: model.get('subject')
      html: model.get('html')
      files: model.get('attachments').map (attachment) -> Ember.Object.create(attachment: attachment)
      bucket: model.get('bucket')

    @controllerFor('templatesEdit').set('form', form)
