Radium.SettingsContactStatusesController = Radium.ArrayController.extend
  actions:
    addNewContactStatus: ->
      Radium.ContactStatus.createRecord(name: "New")
