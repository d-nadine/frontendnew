require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineLostRoute = Radium.PipelineBaseRoute.extend Radium.BulkActionEmailEventsMixin,
  Radium.ClearCheckedMixin,
  model: ->
    @modelFor('pipeline').get('lost')

  setupController: (controller, model) ->
    @_super.apply this, arguments
    controller.set('showHeader', true)
    controller.set('model', model)

  deactivate: ->
    @clearChecked()
