Radium.PeopleDeletionConfirmationController = Radium.ObjectController.extend
  actions:
    deleteAll: ->
      @send 'close'
      @get('controllers.peopleIndex').send 'deleteAll'

  needs: ['peopleIndex']

  checkedTotal: Ember.computed.alias 'controllers.peopleIndex.checkedTotal'