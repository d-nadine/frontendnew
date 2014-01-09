Radium.SaveEmailMixin = Ember.Mixin.create
  actions:
    saveEmail: (form, transitionFolder) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      unless form.get('id')
        email = Radium.Email.createRecord form.get('data')
      else
        email = @modelFor 'emailsEdit'
        email.setProperties form.get('data')

      isDraft = email.get('isDraft')

      email.set 'sentAt', Ember.DateTime.create()

      form.setFilesOnEmail(email)

      if form.get('sendDraft')
        @send 'sendDraft', email
        return

      form.set('isSending', true) unless form.get('isDraft')

      email.one 'didCreate', (result) =>
        Ember.run.next =>
          form.set 'isSubmitted', false
          form.set 'isSending', false
          messagesController = @controllerFor('messages')
          messagesController.tryAdd [email] unless messagesController.get('folder') == "inbox"
          if result.get('isDraft')
            folder = if result.get('isScheduled') then 'scheduled' else 'drafts'
            @send 'flashSuccess', "Email has been saved to the #{folder} folder"
            @controllerFor('messagesSidebar').send 'reset'
            @controllerFor('messages').set('selectedContent', result)
            @transitionTo 'emails.edit', folder, result
          else
            @transitionTo 'emails.sent', email

      email.one 'didUpdate', (result) =>
        Ember.run.next =>
          form.set 'isSubmitted', false
          @send 'flashSuccess', 'Draft saved'
          @transitionTo 'emails.edit', transitionFolder, result if transitionFolder

      email.one 'becameInvalid', =>
        form.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        form.set 'isSending', false
        @send 'flashError', 'An error has occurred and the email has not been sent'

      @store.commit()


