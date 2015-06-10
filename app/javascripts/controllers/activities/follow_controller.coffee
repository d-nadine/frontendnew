Radium.ActivitiesFollowController = Radium.ActivityBaseController.extend
  follower: Ember.computed.alias('meta.follower')
  following: Ember.computed.alias('meta.following')

  useQuotes: Ember.computed 'following', ->
    (@get('following') instanceof Radium.Tag) || (@get('following') instanceof Radium.Deal)

  icon: 'twitter'
