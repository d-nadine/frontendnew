Radium.InviteUserController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: 'users'
  users: Ember.computed.alias 'controllers.users'
  newUserName: null,
  newUserEmail: null,
  isUnique: true
  didInvite: false

  inviteUser: ->
    user = Radium.User.createRecord
      email: @get('newUserEmail')
      name: @get('newUserName')

    @setProperties
      newUserEmail: null
      didInvite: true

  isValidEmail: (->
    email = @get('newUserEmail')
    isUnique = @get('users').filterProperty('email', email).get('length')

    isValid = /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/.test email
    true if isValid and isUnique is 0
  ).property('newUserEmail')

  isDisabled: (->
    username = $.trim(@get('newUserName'))
    isValidUsername = Ember.isEmpty username
    true if @get('isValidEmail') isnt true or Ember.isEmpty username
  ).property('isValidEmail', 'newUserName')

  reset: ->
    @set 'didInvite', false