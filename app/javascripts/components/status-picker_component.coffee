Radium.StatusPickerComponent = Ember.Component.extend
  actions:
    changeStatus: (contact, status) ->
      contact.set 'contactStatus', status

      contact.save().then (result) =>
        @flashMessenger.success 'Status added.'
