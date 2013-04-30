Radium.EmailsShowRoute = Radium.Route.extend
  events:
    sendReply: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')
      email.set 'sender', @controllerFor('currentUser').get('model')

      # Set the time so things sort correctly. It will be updated
      # by the server when the email is actually sent
      email.set 'sentAt', Ember.DateTime.create()

      # This is used to indicate when the email is actually sent.
      # It is independant of 'isSaving'
      email.set 'isSending', true

      # FIXME: hax to close the form. The UI property should be
      # kept on the item controller but there is no way 
      # to pass the item controller along from a separate
      # controller. The reply form itself has a reference
      # to the email it's replying to so we can go through
      # that for now.
      form.set('email.showReplyForm', false)

      form.reset()

      currentlyViewing = @modelFor 'emails.show'

      @store.commit()

      if !currentlyViewing.isIncludedInConversation(email)
        @transitionTo 'emails.show', email
      else
        $.scrollTo 0, duration: 300

    forward: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')
      email.set 'sender', @controllerFor('currentUser').get('model')

      # Set the time so things sort correctly. It will be updated
      # by the server when the email is actually sent
      email.set 'sentAt', Ember.DateTime.create()

      # FIXME: hax for the same reason as above
      form.set 'email.showForwardForm', false

      # This is used to indicate when the email is actually sent.
      # It is independant of 'isSaving'
      email.set 'isSending', true

      Ember.run.next this, (->
        form.set('isSending', false)
      ), 2000

      form.reset()

      @store.commit()

      @transitionTo 'emails.show', email

  setupController: (controller, model) ->
    @controllerFor('messages').set 'selectedContent', model
