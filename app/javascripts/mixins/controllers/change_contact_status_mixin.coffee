Radium.ChangeContactStatusMixin = Ember.Mixin.create
  newPipelineDeal: null

  hasNewPipelineDeal: ( ->
    @get('newPipelineDeal')
  ).property('newPipelineDeal')

  actions:
    changeStatus: (newStatus) ->
      contact = @get('contact')

      return if contact.get('isSaving')

      contact.set('status', newStatus)

      existingDeals = Radium.Deal.all().slice()

      contact.one 'didUpdate', (result) =>
        @send "flashSuccess", "Contact updated!"
        if contact.get('isLead')
          Radium.Deal.find({}).then (deals) =>
            delta = deals.toArray().reject (record) =>
                      existingDeals.contains(record)

            @set 'newPipelineDeal', delta.get('firstObject')

      contact.one 'becameInvalid', (result) =>
        @send 'flashError', result
        @resetModel()

      contact.one 'becameError', (result) =>
        @send 'flashError', "an error happened and the profile could not be updated"
        @resetModel()

      @get('store').commit()

    clearNewPiplineDeal: ->
      @set('newPipelineDeal', null)
