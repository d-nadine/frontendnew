Radium.EmailsEditRoute = Radium.Route.extend
  actions:
    saveEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      data = form.get('data')
      email = @modelFor('emailsEdit')
      email.setProperties data

      isDraft = email.get('isDraft')

      form.get('files').compact().map( (file) -> file.get('attachment'))
          .forEach (attachment) =>
            email.get('attachedFiles').push(attachment.get('id'))

      unless isDraft
        form.set 'isSending', true

      email.one 'didUpdate', (result) =>
        Ember.run.next =>
          form.set 'isSubmitted', false
          form.set 'isSending', false
          unless isDraft
            @transitionTo 'emails.sent', email
            return
          else
            @send 'flashSuccess', 'Draft saved'

      email.one 'becameInvalid', =>
        form.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        form.set 'isSending', false
        @send 'flashError', 'An error has occurred and the email has not been sent'

      @store.commit()

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
    emailForm = Radium.DraftEmailForm.create()
    emailForm.reset()

    emailForm.setProperties
      reference: model
      subject: model.get('subject')
      message: model.get('message')
      isDraft: true
      to: model.get('toList')
      cc: model.get('ccList').map (person) -> person.get('email')
      bcc: model.get('bccList').map (person) -> person.get('email')
      files: model.get('attachments').map (attachment) -> Ember.Object.create(attachment: attachment)
      bucket: model.get('bucket')
      sendTime: model.get('sendTime')

    @controllerFor('emailsEdit').set('emailForm', emailForm)
