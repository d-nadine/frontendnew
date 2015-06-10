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

      follow.save().then =>
        @get('targetObject').send 'flashSuccess', follow.get('successMessage')

        [user, followable].forEach (m) -> m.reload()

  isFollowing: Ember.computed 'followable.followers.[]', 'user', ->
    return true if @get('user') == @get('followable')

    @get('followable.followers').contains @get('user')
