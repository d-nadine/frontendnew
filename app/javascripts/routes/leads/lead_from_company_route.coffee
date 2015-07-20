Radium.LeadsFromCompanyRoute = Radium.Route.extend
  setupController: (controller, model) ->
    controller = @controllerFor 'leadsSingle'
    controller.set 'model', @get 'contactForm'
    initialDealState = @controllerFor('accountSettings').get('model.workflow.firstObject.name')
    controller.set 'model.initialDealState', initialDealState
    initialLeadSource = @controllerFor('account').get('leadSources.firstObject') || ''
    controller.set 'model.initialLeadSource', initialLeadSource
    controller.get('model').reset()
    controller.set 'user', @get('currentUser')
    controller.set 'company', model
    controller.set 'model.companyName', model.get('name')
    controller.set 'model.user', @get('currentUser')
    controller.set 'emailAddresses', controller.get('model.emailAddresses')
    controller.set 'phoneNumbers', controller.get('model.phoneNumbers')
    controller.set 'addresses', controller.get('model.addresses')

  renderTemplate: ->
    @render 'leads.single',
      controller: 'leadsSingle'

  contactForm:  Radium.computed.newForm('contact')

  # FIXME: remove defaults and just use reset?
  contactFormDefaults: Ember.computed ->
    isNew: true
    isSubmitted: false
    isSaving: false
