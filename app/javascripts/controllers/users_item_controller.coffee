Radium.UserItemController = Radium.ObjectController.extend Ember.Evented,
  isCurrentUser: Ember.computed 'model', ->
    @get('model') == @get('currentUser')

  toggleIsAdmin: ->
    return if @get('isSaving')

    user = @get('model')

    isAdmin = @get('model.isAdmin')

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
