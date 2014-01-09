Radium.EmailsShowRoute = Radium.Route.extend Radium.SaveEmailMixin,
  actions:
    sendReply: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      # Set the time so things sort correctly. It will be updated
      # by the server when the email is actually sent
      email.set 'sentAt', Ember.DateTime.create()

      form.setFilesOnEmail(email)

      # FIXME: hax to close the form. The UI property should be
      # kept on the item controller but there is no way 
      # to pass the item controller along from a separate
      # controller. The reply form itself has a reference
      # to the email it's replying to so we can go through
      # that for now.
      form.set('email.showReplyForm', false)

      currentlyViewing = @modelFor 'emails.show'

      email.one 'didCreate', =>
        form.reset()

        Ember.run.next =>
          @transitionTo 'emails.show', email

      email.one 'becameInvalid', =>
        @send 'flashError', email
        email.reset() 

      email.one 'becameError', =>
        @send 'flashError', 'An error has occurred and the eamil has not been sent'
        email.reset() 

      @store.commit()

    forward: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      # Set the time so things sort correctly. It will be updated
      # by the server when the email is actually sent
      email.set 'sentAt', Ember.DateTime.create()

      # FIXME: hax for the same reason as above
      form.set 'email.showForwardForm', false

      email.one 'didCreate', =>
        form.reset()
        Ember.run.next =>
          @transitionTo 'emails.show', email

      email.one 'becameInvalid', =>
        @send 'flashError',  email

      email.one 'becameError', =>
        @send 'flashError', 'An error has occurred and the eamil has not been sent'

      @store.commit()

  setupController: (controller, model) ->
    model.set 'isRead', true
    @store.commit()

    controller.send 'clearNewPipelineDeal'

    @controllerFor('messages').set 'selectedContent', model
    controller.set 'model', model
