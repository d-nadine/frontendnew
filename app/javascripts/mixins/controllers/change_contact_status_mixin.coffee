Radium.ChangeContactStatusMixin = Ember.Mixin.create
  actions:
    changeStatus: (newStatus) ->
      contact = @get('contact')

      return if contact.get('isSaving')

      contact.set('status', newStatus)

      existingDeals = Radium.Deal.all().slice()

      contact.save().then((result) =>
        @send "flashSuccess", "Contact updated!"
      ).catch (error) =>
        @resetModel()
