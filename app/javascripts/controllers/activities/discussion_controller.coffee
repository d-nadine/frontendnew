Radium.ActivitiesDiscussionController = Radium.ObjectController.extend
  topic: Ember.computed.alias('reference.topic')
  poster: Ember.computed.alias('reference.user')
  participants: Ember.computed.alias('reference.users')

  icon: 'chat'
