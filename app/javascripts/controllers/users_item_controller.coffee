Radium.UserItemController = Radium.ObjectController.extend Ember.Evented,
  isCurrentUser: ( ->
    @get('model') == @get('currentUser')
  ).property('model')

  toggleIsAdmin: ->
    return if @get('isSaving')

    user = @get('model')

    isAdmin = @get('isAdmin')

    user.set('isAdmin', not isAdmin)

    user.one 'didUpdate', =>
      message = if isAdmin
                  'user no lonber admin'
                else
                  'user is now an admin'

      @send 'flashSuccess', message

    user.one 'becameInvalid', (result) =>
      @send 'flashError', result

    user.one 'becameError', (result) =>
      @send 'flashError', result

    @get('store').commit()
