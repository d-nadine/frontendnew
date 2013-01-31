require 'radium/routes/drawer_support_mixin'

Radium.PipelineLeadsRoute = Em.Route.extend Radium.DrawerSupportMixin,
  events:
    toggleSearch: ->
      @toggleDrawer 'pipeline/lead_search'

    toggleChecked: ->
      @controllerFor('pipelineLeads').toggleChecked()

  setupController: ->
    @controllerFor('pipelineStatus').set('status', 'lead')

  model: ->
    Radium.Contact.find(statusFor: 'lead')

  renderTemplate: ->
    @render 'pipeline/pipeline_lead'
      into: 'pipeline'

