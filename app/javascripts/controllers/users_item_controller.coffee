Radium.UserItemController = Radium.ObjectController.extend Ember.Evented,
  actions:
    toggleIsAdmin: ->
      return if @get('isSaving')

      user = @get('model')

      isAdmin = @get('model.isAdmin')

      user.set('isAdmin', not isAdmin)

      user.save().then(=>
        message = if isAdmin
                    'user no longer admin'
                  else
                    'user is now an admin'

        @send 'flashSuccess', message
      ).catch (error) =>
        @resetModel()

  isCurrentUser: Ember.computed 'model', ->
    @get('model') == @get('currentUser')
