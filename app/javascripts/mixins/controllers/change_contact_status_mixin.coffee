Radium.ChangeContactStatusMixin = Ember.Mixin.create
  actions:
    changeStatus: (newStatus) ->
      contact = @get('contact')

      return if contact.get('isSaving')

      contact.set('status', newStatus)

      existingDeals = Radium.Deal.all().slice()

      contact.one 'didUpdate', (result) =>
        @send "flashSuccess", "Contact updated!"

      contact.one 'becameInvalid', (result) =>
        @send 'flashError', result
        @resetModel()

      contact.one 'becameError', (result) =>
        @send 'flashError', "an error happened and the profile could not be updated"
        @resetModel()

      @get('store').commit()
