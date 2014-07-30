Radium.FollowActionsMixin = Ember.Mixin.create
  actions:
    follow: (followable) ->
      Ember.assert "You can only follow contacts or users", followable.constructor in [Radium.Contact, Radium.User]

      user = @controllerFor('currentUser').get('content')

      follow = Radium.Follow.createRecord
                                follower: user
                                followable: followable

      Ember.assert "followable has not been set.", follow.get('followable')

      follow.one 'didCreate', =>
        @send 'flashSuccess', "You are now following #{followable.displayName}"

      follow.one "becameError", =>
        @send "flashError", "An error has occurred and you cannot follow #{followable.displayName}"
        user.reset()

      follow.one "becameInvalid", (result) =>
        @send "flashError", result
        user.reset()

      @store.commit()
