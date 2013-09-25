Radium.InviteUserController = Radium.ObjectController.extend Radium.CurrentUserMixin,
  actions:
    inviteUser: ->
      user = Radium.UserInvitation.createRecord
        email: @get('newUserEmail')

      user.one 'didCreate', =>
        @send 'flashSuccess', 'The invitation has been sent'
        @set 'newUserEmail', null

      user.one 'becameInvalid', =>
        @send 'flashError', user
        user.deleteRecord()

      user.one 'becameError', =>
        @send 'flashError', 'An error has occurred and the invitation cannot be sent.'
        user.deleteRecord()

      user.get('transaction').commit()

  needs: 'users'
  users: Ember.computed.alias 'controllers.users'
  newUserEmail: null,

  # FIXME: Should be done on the server and return 422
  isDuplicate: ( ->
    email = @get('newUserEmail')
    !!@get('users').filterProperty('email', email).get('length')
  ).property('newUserEmail')

  isValidEmail: (->
    email = @get('newUserEmail')
    isValid = /^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/.test email
    isValid and not @get('isDuplicate')
  ).property('newUserEmail', 'isDuplicate')

  isDisabled: Ember.computed.not 'isValidEmail'
