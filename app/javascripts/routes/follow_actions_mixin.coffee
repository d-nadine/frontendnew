Radium.FollowActionsMixin = Ember.Mixin.create
  actions:
    follow: (followable) ->
      Ember.assert "You can only follow contacts or users", followable.constructor in [Radium.Contact, Radium.User]

      collection = if followable.constructor is Radium.Contact
                     "contactsFollowed"
                   else if followable.constructor is Radium.User
                     "usersFollowed"

      user = @controllerFor('currentUser').get('content')

      user.get(collection).addObject followable

      user.one 'didUpdate', ->
        @send 'flashSuccess', "You are now following #{followable.displayName}"

      user.one "becameError", ->
        @send "flashError", "An error has occurred and you cannot follow #{followable.displayName}"
        user.reset()

      user.one "becameInvalid", (result) ->
        @send "flashError", result
        user.reset()

      @store.commit()
