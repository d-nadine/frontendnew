Radium.PeopleDeletionConfirmationController = Radium.ObjectController.extend
  actions:
    deleteAll: ->
      @send 'close'
      @get('controllers.peopleIndex').send 'deleteAll'

  needs: ['peopleIndex']

  checkedTotal: Ember.computed.alias 'controllers.peopleIndex.checkedTotal'

Radium.AddressbookDeletionConfirmationController = Radium.ObjectController.extend
  actions:
    deleteAll: ->
      @send 'close'
      @get('controllers.addressbookCompanies').send 'deleteAll'

  needs: ['addressbookCompanies']

  checkedTotal: Ember.computed.alias 'controllers.addressbookCompanies.checkedTotal'
