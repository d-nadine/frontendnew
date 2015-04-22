Radium.BulkRecipientComponent = Ember.Component.extend
  classNameBindings: [':item']

  isTag: Ember.computed 'recipient.type', ->
    @get('recipient.type') == 'tag'
