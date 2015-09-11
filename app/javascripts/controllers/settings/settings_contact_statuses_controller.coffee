Radium.SettingsContactStatusesController = Radium.Controller.extend
  actions:
    refreshContactStatuses: (model) ->
      @get('contactStatuses').set 'model', Radium.ContactStatus.find({})

      false

    addNewContactStatus: ->
      Radium.ContactStatus.createRecord(name: "New")

      false

  contactStatuses: Ember.computed ->
    @container.lookup('controller:contactStatuses')
