require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineLostRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin, 
  Radium.ClearCheckedMixin,
  model: ->
    @modelFor('pipeline').get('lost')

  setupController: (controller, model) ->
    controller.set('showHeader', true)
    controller.set('model', model)

  deactivate: ->
    @clearChecked()
