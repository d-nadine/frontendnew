Radium.DealsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    dealForm = @get 'dealForm'
    controller.set 'model', dealForm 
    controller.get('model').reset()
    controller.set 'model.user', @controllerFor('currentUser').get('model')
    dealForm.get('forecast').pushObjects @controllerFor('accountSettings').get('dealChecklist').map (checkListItem) ->
                                                                          Ember.Object.create(checkListItem)
    dealsController.set 'status', @controllerFor('accountSettings').get('dealStates.firstObject')

  dealForm:  Radium.computed.newForm('deal')

  dealFormDefaults: ( ->
    isNew: true
    contact: null
    description: ''
    todo: null
    email: null
    forecast: Ember.A()
  ).property()
