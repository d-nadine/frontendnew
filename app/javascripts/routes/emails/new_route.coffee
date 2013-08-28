Radium.EmailsNewRoute = Ember.Route.extend
  events:
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sentAt', Ember.DateTime.create()

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

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
