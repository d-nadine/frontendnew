Radium.BulkRecipientsComponent = Ember.Component.extend
  actions:
    removeFromBulkList: (recipient) ->
      @sendAction "removeFromBulkList", recipient

      false

  classNameBindings: [':recipients']
