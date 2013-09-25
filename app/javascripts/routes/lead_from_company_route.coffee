Radium.LeadsFromCompanyRoute = Radium.Route.extend
  setupController: (controller, model) ->
    controller = @controllerFor 'leadsNew'
    controller.set 'model', @get 'contactForm'
    initialStatus = @controllerFor('leadStatuses').get('content.firstObject.value')
    controller.set 'model.initialStatus', initialStatus
    initialDealState = @controllerFor('accountSettings').get('model.workflow.firstObject.name')
    controller.set 'model.initialDealState', initialDealState
    initialLeadSource = @controllerFor('account').get('leadSources.firstObject') || ''
    controller.set 'model.initialLeadSource', initialLeadSource
    controller.get('model').reset()
    controller.set 'user', @controllerFor('currentUser').get('model')
    controller.set 'company', model
    controller.set 'companyName', model.get('name')
    controller.set 'expandImmediately', true 

  renderTemplate: ->
    @render 'leads.new',
      controller: 'leadsNew'

  contactForm:  Radium.computed.newForm('contact')

  # FIXME: remove defaults and just use reset?
  contactFormDefaults: ( ->
    isNew: true
    isSubmitted: false
    isSaving: false
  ).property()
