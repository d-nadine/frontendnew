Radium.EmailsShowRoute = Radium.Route.extend
  events:
    sendReply: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      # Set the time so things sort correctly. It will be updated
      # by the server when the email is actually sent
      email.set 'sentAt', Ember.DateTime.create()

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
          if !currentlyViewing.isIncludedInConversation(email)
            @transitionTo 'emails.show', email
          else
            $.scrollTo 0, duration: 300

      email.one 'becameInvalid', =>
        Radium.Utils.generateErrorSummary email

      email.one 'becameError', =>
        Radium.Utils.notifyError 'An error has occurred and the eamil has not been sent'

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
        Radium.Utils.generateErrorSummary email

      email.one 'becameError', =>
        Radium.Utils.notifyError 'An error has occurred and the eamil has not been sent'

      @store.commit()

  setupController: (controller, model) ->
    model.set 'isRead', true
    @store.commit()

    @controllerFor('messages').set 'selectedContent', model
    controller.set 'model', model
