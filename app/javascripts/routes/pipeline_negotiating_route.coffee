require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineNegotiatingRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    @modelFor('pipeline')
