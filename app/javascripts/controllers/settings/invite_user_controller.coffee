Radium.InviteUserController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: 'users'
  users: Ember.computed.alias 'controllers.users'
  newUserEmail: null,
  didInvite: false

  inviteUser: ->
    user = Radium.User.createRecord
      email: @get('newUserEmail')
      name: "New user"

    @setProperties
      newUserEmail: null
      didInvite: true

  isValidEmail: (->
    email = @get('newUserEmail')
    isValid = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/.test email
    if isValid then false else true
  ).property('newUserEmail')

  reset: ->
    @set 'didInvite', false