Radium.MessagesBulkActionItemController = Radium.ObjectController.extend
  summary: Ember.computed 'subject', 'topic', ->
    @get('subject') || @get('topic')

  person: Ember.computed 'user', 'sender', ->
    @get('sender') || @get('user')

  timestamp: Ember.computed 'sentAt', 'createdAt', ->
    @get('sentAt') || @get('createdAt')

  isEmail: Ember.computed ->
    @get('content') instanceof Radium.Email
