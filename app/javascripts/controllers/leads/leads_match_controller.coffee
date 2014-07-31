Radium.LeadsMatchController = Ember.ObjectController.extend
  importSuccess: false

  actions:
    importContacts: ->
      @setProperties
        importSuccess: true
        showLargeImportMessage: false

      return
