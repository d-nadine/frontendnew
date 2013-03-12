Radium.MessagesBulkActionItemController = Ember.ObjectController.extend
  summary: (->
    @get('subject') || @get('topic')
  ).property('subject', 'topic')

  person: (->
    @get('sender') || @get('user')
  ).property('user', 'sender')

  timestamp: (->
    @get('sentAt') || @get('createdAt')
  ).property('sentAt', 'createdAt')

  isEmail: (->
    @get('content') instanceof Radium.Email
  ).property()
