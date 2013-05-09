Radium.EmailsNewRoute = Ember.Route.extend
  events: 
    submit: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sender', @controllerFor('currentUser').get('model')

      @transitionTo 'emails.sent', email

      @store.commit()

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
