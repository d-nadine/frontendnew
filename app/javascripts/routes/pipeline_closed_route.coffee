require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineClosedRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    @modelFor('pipeline').get('closed')

  setupController: (controller, model) ->
    controller.set('showHeader', true)
    controller.set('model', model)

  renderTemplate: ->
    @render 'pipeline/closed',
      into: 'pipeline'
