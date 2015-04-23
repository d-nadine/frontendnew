Radium.BulkRecipientComponent = Ember.Component.extend
  actions:
    removeFromBulkList: (recipient) ->
      @sendAction "removeFromBulkList", recipient

      false

  classNameBindings: [':item']

  isTag: Ember.computed 'recipient.type', ->
    @get('recipient.type') == 'tag'
