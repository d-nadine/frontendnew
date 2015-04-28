Radium.TemplatesEditRoute = Ember.Route.extend
  templateForm: Radium.TemplateForm.create()

  afterModel: (model, transition) ->
    form = @templateForm

    form.reset()

    form.setProperties
      id: model.get('id')
      subject: model.get('subject')
      html: model.get('html')
      files: model.get('attachments').map (attachment) -> Ember.Object.create(attachment: attachment)
      bucket: model.get('bucket')

    @controllerFor('templatesEdit').set('form', form)