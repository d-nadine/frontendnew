Radium.DealNewBaseRoute = Radium.Route.extend
  setupController: (controller, model) ->
    dealForm = @get 'dealForm'
    controller.set 'model', dealForm
    initialStatus = @controllerFor('accountSettings').get('model.workflow.firstObject.name')
    controller.get('model').reset(initialStatus)
    controller.set 'status', initialStatus

  dealForm:  Radium.computed.newForm('deal')

  dealFormDefaults: ( ->
    isNew: true
    contact: null
    description: ''
    todo: null
    email: null
    checklist: Ember.A()
  ).property()
