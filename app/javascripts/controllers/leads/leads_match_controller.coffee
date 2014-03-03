Radium.LeadsMatchController = Ember.ObjectController.extend
  showLargeImportMessage: true
  importSuccess: false

  actions:
    importContacts: ->
      @setProperties
        importSuccess: true
        showLargeImportMessage: false
      return

    dismissLargeImportMessage: ->
      @set('showLargeImportMessage', false)

    cancelLargeImportMessage: ->
      @transitionTo('leads.import')