Radium.DealsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    dealForm = @get 'dealForm'
    controller.set 'model', dealForm 
    controller.get('model').reset()
    controller.set 'model.user', @controllerFor('currentUser').get('model')
    dealForm.get('checklist').pushObjects @controllerFor('accountSettings').get('dealChecklist').map (checkListItem) ->
                                                                          Ember.Object.create(checkListItem)
    controller.set 'status', @controllerFor('accountSettings').get('negotiatingStates.firstObject')

  dealForm:  Radium.computed.newForm('deal')

  dealFormDefaults: ( ->
    isNew: true
    contact: null
    description: ''
    todo: null
    email: null
    checklist: Ember.A()
  ).property()
