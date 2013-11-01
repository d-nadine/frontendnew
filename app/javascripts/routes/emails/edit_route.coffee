Radium.EmailsEditRoute = Radium.Route.extend
  actions:
    deleteFromEditor: ->
      messagesController = @controllerFor('messages')

      folder = messagesController.get('folder')

      email = @modelFor('emailsEdit')

      messagesController.removeObject(email) if folder == 'drafts'

      @send 'delete', email

      @controllerFor('messagesSidebar').send 'reset'
      @transitionTo 'messages', messagesController.get('folder')

      false

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
