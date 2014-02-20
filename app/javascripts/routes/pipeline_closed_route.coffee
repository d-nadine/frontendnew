require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineClosedRoute = Radium.PipelineBaseRoute.extend Radium.BulkActionEmailEventsMixin,
  Radium.ClearCheckedMixin,
  model: ->
    @modelFor('pipeline').get('closed')

  setupController: (controller, model) ->
    @_super.apply this, arguments
    controller.set('showHeader', true)
    controller.set('model', model)

  renderTemplate: ->
    @render 'pipeline/closed',
      into: 'pipeline'
