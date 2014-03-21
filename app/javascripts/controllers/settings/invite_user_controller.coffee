Radium.InviteUserController = Radium.ObjectController.extend Radium.CurrentUserMixin,
  actions:
    inviteUser: ->
      user = Radium.UserInvitation.createRecord
        email: @get('newUserEmail')

      user.one 'didCreate', =>
        @send 'flashSuccess', 'The invitation has been sent'
        @set 'newUserEmail', null

      user.one 'becameInvalid', =>
        error = user.get('errors.error')

        if new RegExp('\\b' + @get('plan') + '\\b').test(error)
          @set 'error', error
        else
          @send 'flashError', user

        user.deleteRecord()

      user.one 'becameError', =>
        @send 'flashError', 'An error has occurred and the invitation cannot be sent.'
        user.deleteRecord()

      user.get('transaction').commit()

    reset: ->
      @setProperties
        newUserEmail: null
        error: null

  needs: 'users'
  users: Ember.computed.alias 'controllers.users'
  newUserEmail: null
  error: null

  # FIXME: Should be done on the server and return 422
  isDuplicate: ( ->
    email = @get('newUserEmail')
    !!@get('users').filterProperty('email', email).get('length')
  ).property('newUserEmail')

  isValidEmail: (->
    email = @get('newUserEmail')
    isValid = @emailIsValid email
    isValid and not @get('isDuplicate')
  ).property('newUserEmail', 'isDuplicate')

  isDisabled: Ember.computed.not 'isValidEmail'
