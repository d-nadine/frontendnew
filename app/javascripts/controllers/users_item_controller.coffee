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
                  'user no longer admin'
                else
                  'user is now an admin'

      @send 'flashSuccess', message

    user.one 'becameInvalid', (result) =>
      @send 'flashError', result
      @resetModel()

    user.one 'becameError', (result) =>
      @send 'flashError', result
      @resetModel()

    @get('store').commit()
