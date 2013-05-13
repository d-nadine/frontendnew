Radium.LeadsFromCompanyRoute = Radium.Route.extend
  setupController: (controller, model) ->
    leadsController = @controllerFor('leadsNew')
    leadsController.set 'model', @get 'contactForm'
    leadsController.get('model').reset()
    leadsController.set 'user', @controllerFor('currentUser').get('model')
    leadsController.set 'company', model
    leadsController.set 'companyName', model.get('name')
    leadsController.set 'status', model.get('status')
    leadsController.set('source', 'Lead Form')
    leadsController.set 'expandImmediately', true

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
