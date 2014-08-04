Radium.FollowFeedComponent = Ember.Component.extend
  actions:
    follow: ->
      @send 'perform', Radium.Follow

    unfollow: ->
      @send 'perform', Radium.Unfollow

    perform: (klass) ->
      followable = @get('followable')

      Ember.assert "You can only follow companies, contacts or users", followable.constructor in [Radium.Contact, Radium.User, Radium.Company]

      user = @get('user')

      follow = klass.createRecord
                          follower: user
                          followable: followable

      Ember.assert "followable has not been set.", follow.get('followable')

      follow.one 'didCreate', =>
        @get('targetObject').send 'flashSuccess', follow.get('successMessage')

        [user, followable].forEach (m) -> m.reload()

      follow.one "becameError", =>
        @get('targetObject').send "flashError", follow.get('errorMessage')
        user.reset()

      follow.one "becameInvalid", (result) =>
        @get('targetObject').send "flashError", result
        user.reset()

      @get('store').commit()

  isFollowing: Ember.computed 'followable.followers.[]', 'user', ->
    return true if @get('user') == @get('followable')

    @get('followable.followers').contains @get('user')

  store: Ember.computed ->
    this.container.lookup "store:main"
