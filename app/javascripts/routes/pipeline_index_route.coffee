require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineIndexRoute = Radium.PipelineBaseRoute.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    @modelFor('pipeline')

  setupController: (controller, model) ->
    @_super.apply this, arguments
    controller.set('model', model)

  deactivate: ->
    @controller.set 'searchText', null
