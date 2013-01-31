Radium.PipelineRoute = Ember.Route.extend
  events:
    toggleSearch: ->
      @toggleDrawer 'pipeline/lead_search'

    toggleChecked: ->
      @controllerFor('pipelineLeads').toggleChecked()

  setupController: ->
    # FIXME: Replace with real query
    contacts = Radium.Contact.all()
    deals = Radium.Deal.all()
    @controllerFor('pipelineStatus').set('contacts', contacts)
    @controllerFor('pipelineStatus').set('deals', deals)

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons'
      into: 'drawer_panel'
      outlet: 'buttons'

