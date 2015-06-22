Radium.XFollowersComponent = Ember.Component.extend
  action:
    follow: ->
      @sendAction "follow"

      false

    unfollow: ->
      @sendAction "unfollow"

      false