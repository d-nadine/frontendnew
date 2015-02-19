Radium.LeadsSingleRoute = Ember.Route.extend
  setupController: (controller) ->
    contactForm = @get('contactForm')
    controller.set 'model', contactForm
    controller.set 'contactForm', contactForm
    controller.get('model').reset()
    controller.set 'model.user', @controllerFor('currentUser').get('model')

  contactForm:  Radium.computed.newForm('contact')

  contactFormDefaults: Ember.computed ->
    isNew: true
    isSubmitted: false
    isSaving: false

  deactivate: ->
    @controller.get('model').reset()
