Radium.FollowFeedComponent = Ember.Component.extend
  actions:
    follow: ->
      followable = @get('followable')

      Ember.assert "You can only follow contacts or users", followable.constructor in [Radium.Contact, Radium.User]

      user = @get('user')

      follow = Radium.Follow.createRecord
                                follower: user
                                followable: followable

      Ember.assert "followable has not been set.", follow.get('followable')

      follow.one 'didCreate', =>
        @send 'flashSuccess', "You are now following #{followable.get('displayName')}"

        [user, followable].forEach (m) -> m.reload()

      follow.one "becameError", =>
        @send "flashError", "An error has occurred and you cannot follow #{followable.displayName}"
        user.reset()

      follow.one "becameInvalid", (result) =>
        @send "flashError", result
        user.reset()

      @get('store').commit()

  isFollowing: Ember.computed 'followable.followers.[]', 'user', ->
    return true if @get('user') == @get('followable')

    @get('followable.followers').contains @get('user')

  store: Ember.computed ->
    this.container.lookup "store:main"
