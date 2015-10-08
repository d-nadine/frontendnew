Radium.SendEmailMixin = Ember.Mixin.create
  actions:
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sentAt', Ember.DateTime.create()

      form.setFilesOnModel(email)

      form.set 'isSending', true

      email.save().then =>
        Ember.run.next =>
          form.set 'isSubmitted', false
          form.set 'isSending', false
          @transitionTo 'emails.sent', email
