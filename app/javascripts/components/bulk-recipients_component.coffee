Radium.BulkRecipientsComponent = Ember.Component.extend
  actions:
    removeFromToList: (recipient) ->
      @sendAction "removeFromToList", recipient

      false

  classNameBindings: [':recipients']
