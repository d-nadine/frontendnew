Radium.LeadsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'model', @get 'contactForm'
    initialStatus = @controllerFor('leadStatuses').get('content.firstObject.value')
    controller.set 'model.initialStatus', initialStatus
    initialDealState = @controllerFor('accountSettings').get('model.workflow.firstObject.name')
    controller.set 'model.initialDealState', initialDealState
    controller.get('model').reset()
    controller.set 'model.user', @controllerFor('currentUser').get('model')

  contactForm:  Radium.computed.newForm('contact')

  # FIXME: Should we not just use reset?
  contactFormDefaults: ( ->
    isNew: true
    isSubmitted: false
    isSaving: false
  ).property()
