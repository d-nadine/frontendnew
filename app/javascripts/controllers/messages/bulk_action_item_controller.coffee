Radium.MessagesBulkActionItemController = Ember.ObjectController.extend
  summary: (->
    @get('message') || @get('topic')
  ).property('message')

  person: (->
    @get('sender') || @get('user')
  ).property('user', 'sender')

  timestamp: (->
    @get('sentAt') || @get('createdAt')
  ).property('sentAt', 'createdAt')
