Radium.InviteUserComponent = Ember.Component.extend
  actions:
    inviteUser: ->
      user = Radium.UserInvitation.createRecord
        email: @get('newUserEmail')

      user.one 'didCreate', =>
        @sendAction 'flashSuccess', 'The invitation has been sent'
        @set 'newUserEmail', null

      user.one 'becameInvalid', =>
        error = user.get('errors.error')

        if new RegExp('\\b' + @get('plan') + '\\b').test(error)
          @set 'error', error
        else
          @sendAction 'flashError', user

        user.deleteRecord()

      user.one 'becameError', =>
        @sendAction 'flashError', 'An error has occurred and the invitation cannot be sent.'
        user.deleteRecord()

      user.get('transaction').commit()

  reset: ->
    @setProperties
      newUserEmail: null
      error: null

  classNameBindings: [':form-inline', 'didInvite:success']

  newUserEmail: null
  error: null

  isDuplicate: Ember.computed 'newUserEmail', ->
    email = @get('newUserEmail')
    !!@get('users').filterProperty('email', email).get('length')

  isValidEmail: Ember.computed 'newUserEmail', 'isDuplicate', ->
    email = @get('newUserEmail')
    isValid = @emailIsValid email
    isValid and not @get('isDuplicate')

  isDisabled: Ember.computed.not 'isValidEmail'

  didInviteUser: Ember.observer 'didInvite', ->
    if @get('didInvite')
      Ember.run.later(=>
        $.when(@$('.help-inline').fadeOut()).then(=>
          @reset()
        )
      , 1500)
