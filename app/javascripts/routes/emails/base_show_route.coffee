Radium.ShowRouteBase = Radium.Route.extend
  actions:
    sendReply: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      reply = Radium.Email.createRecord form.get('data')

      # Set the time so things sort correctly. It will be updated
      # by the server when the email is actually sent
      reply.set 'sentAt', Ember.DateTime.create()

      form.setFilesOnModel(reply)

      # FIXME: hax to close the form. The UI property should be
      # kept on the item controller but there is no way
      # to pass the item controller along from a separate
      # controller. The reply form itself has a reference
      # to the email it's replying to so we can go through
      # that for now.
      form.set('repliedTo.showReplyForm', false)

      reply.save().then =>
        form.reset()

        Ember.run.next =>
          @transitionTo 'emails.sent', reply

        reply.reset()

    forward: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      # Set the time so things sort correctly. It will be updated
      # by the server when the email is actually sent
      email.set 'sentAt', Ember.DateTime.create()

      # FIXME: hax for the same reason as above
      form.set 'email.showForwardForm', false

      email.save().then =>
        form.reset()
        Ember.run.next =>
          @transitionTo 'emails.show', email
