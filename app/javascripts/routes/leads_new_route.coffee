Radium.LeadsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'model', @get 'contactForm'
    controller.get('model').reset()
    controller.set 'model.assignedTo', @controllerFor('currentUser').get('model')

  contactForm:  Radium.computed.newForm('contact')

  # FIXME: Should we not just use reset?
  contactFormDefaults: ( ->
    isNew: true
    isSubmitted: false
    isSaving: false
  ).property()
