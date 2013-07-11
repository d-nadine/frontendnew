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
        Radium.Utils.generateErrorSummary email

      email.one 'becameError', =>
        form.set 'isSending', false
        Radium.Utils.notifyError 'An error has occurred and the eamil has not been sent'

      @store.commit()

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
