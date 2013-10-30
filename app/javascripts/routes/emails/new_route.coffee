Radium.EmailsNewRoute = Ember.Route.extend
  actions:
    willTransition: (transition) ->
      if transition.targetName == "messages.index"
        controller = @controllerFor('messages')
        @controllerFor('messagesSidebar').send 'reset'
        Ember.run.next =>
          if controller.get('model.length')
            @transitionTo 'emails.show', "inbox", controller.get('firstObject')
          else
            @transitionTo 'messages.empty', "inbox"

        return false

      true

    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sentAt', Ember.DateTime.create()

      form.get('files').map( (file) -> file.get('attachment'))
          .forEach (attachment) =>
            email.get('attachedFiles').push(attachment.get('id'))

      form.set 'isSending', true

      email.one 'didCreate', =>
        Ember.run.next =>
          form.set 'isSubmitted', false
          form.set 'isSending', false
          @transitionTo 'emails.sent', email

      email.one 'becameInvalid', =>
        form.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        form.set 'isSending', false
        @send 'flashError', 'An error has occurred and the email has not been sent'

      @store.commit()

    cancelCreate: ->
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        @transitionTo 'messages', @controllerFor('messages').get('folder')

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
    @controllerFor('messagesSidebar').send 'reset'
