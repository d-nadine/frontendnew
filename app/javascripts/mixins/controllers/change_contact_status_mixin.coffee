Radium.ChangeContactStatusMixin = Ember.Mixin.create
  changeStatus: (newStatus) ->
    contact = @get('contact')

    return if contact.get('isSaving')

    contact.set('status', newStatus)

    contact.one 'didUpdate', =>
      @send "flashSuccess", "Contact updated!"
      if contact.get('isLead')
        Radium.Deal.find()

    contact.one 'becameInvalid', (result) =>
      @send 'flashError', result
      @resetModel()

    contact.one 'becameError', (result) =>
      @send 'flashError', "an error happened and the profile could not be updated"
      @resetModel()

    @get('store').commit()
