Radium.ActivitiesFollowController = Radium.ObjectController.extend
  follower: Ember.computed.alias('meta.follower')
  following: Ember.computed.alias('meta.following')

  useQuotes: (->
    (@get('following') instanceof Radium.Group) || (@get('following') instanceof Radium.Deal)
  ).property('following')

  icon: 'twitter'
