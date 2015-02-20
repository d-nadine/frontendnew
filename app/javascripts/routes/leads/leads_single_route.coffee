Radium.LeadsSingleRoute = Ember.Route.extend
  setupController: (controller) ->
    contactForm = @get('contactForm')
    controller.set 'model', contactForm
    controller.set 'contactForm', contactForm
    controller.get('model').reset()
    controller.set 'model.user', @controllerFor('currentUser').get('model')
    controller.set 'emailAddresses', controller.get('model.emailAddresses')
    controller.set 'phoneNumbers', controller.get('model.phoneNumbers')
    controller.set 'addresses', controller.get('model.addresses')

  contactForm:  Radium.computed.newForm('contact')

  contactFormDefaults: Ember.computed ->
    isNew: true
    isSubmitted: false
    isSaving: false

  deactivate: ->
    @controller.get('model').reset()
