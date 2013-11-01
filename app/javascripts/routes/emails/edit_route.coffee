Radium.EmailsEditRoute = Radium.Route.extend
  afterModel: (model, transition) ->
    emailForm = Radium.NewEmailForm.create()
    emailForm.reset()

    emailForm.setProperties 
      subject: model.get('subject')
      message: model.get('message')
      isDraft: model.get('isDraft')
      to: model.get('toList')
      cc: model.get('ccList').map (person) -> person.get('email')
      bcc: model.get('bccList').map (person) -> person.get('email')
      files: model.get('attachments').map (attachment) -> Ember.Object.create(attachment: attachment)

    @controllerFor('emailsEdit').set('emailForm', emailForm)
