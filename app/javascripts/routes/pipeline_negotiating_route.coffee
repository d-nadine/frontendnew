require 'radium/routes/drawer_support_mixin'

Radium.PipelineNegotiatingRoute = Em.Route.extend Radium.DrawerSupportMixin,
  events:
    toggleSearch: ->
      @toggleDrawer 'pipeline/negotiating_search'

    toggleChecked: ->
      @controllerFor('pipelineLeads').toggleChecked()

  setupController: ->
    @controllerFor('pipelineStatus').set('status', 'negotiating')

  model: (params) ->
    return Radium.Deal.find(statusFor: 'negotiating')

  renderTemplate: ->
    @render 'pipeline/pipeline_negotiating'
      into: 'pipeline'

