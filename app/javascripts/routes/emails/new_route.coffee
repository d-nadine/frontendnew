require 'routes/mixins/send_email_mixin'

Radium.EmailsNewRoute = Ember.Route.extend Radium.SendEmailMixin,
  actions:
    willTransition: (transition) ->
      if transition.targetName == "messages.index"
        controller = @controllerFor('messages')
        @controllerFor('messagesSidebar').send 'reset'

        @transitionTo 'messages.index', transition.params.folder

        return false

      true

    saveEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sentAt', Ember.DateTime.create()

      form.get('files').map( (file) -> file.get('attachment'))
          .forEach (attachment) =>
            email.get('attachedFiles').push(attachment.get('id'))

      form.set('isSending', true) unless form.get('isDraft')

      email.one 'didCreate', (result) =>
        Ember.run.next =>
          form.set 'isSubmitted', false
          form.set 'isSending', false
          messagesController = @controllerFor('messages')
          messagesController.tryAdd [email] unless messagesController.get('folder') == "inbox"
          if result.get('isDraft')
            @send 'flashSuccess', 'Email has been saved to the drafts folder'
            @controllerFor('messagesSidebar').send 'reset'
            @controllerFor('messages').set('selectedContent', result)
            @transitionTo 'emails.edit', 'drafts', result
          else
            @transitionTo 'emails.sent', email

      email.one 'becameInvalid', =>
        form.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        form.set 'isSending', false
        @send 'flashError', 'An error has occurred and the email has not been sent'

      @store.commit()

    deleteFromEditor: ->
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        @transitionTo 'messages', @controllerFor('messages').get('folder')

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
    @controllerFor('messagesSidebar').send 'reset'
