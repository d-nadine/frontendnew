Radium.BulkRecipientComponent = Ember.Component.extend
  actions:
    removeFromToList: (recipient) ->
      @sendAction "removeFromToList", recipient

      false

  classNameBindings: [':item']

  isTag: Ember.computed 'recipient.type', ->
    @get('recipient.type') == 'tag'
