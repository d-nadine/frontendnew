require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineLeadsRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    @modelFor('pipeline').get('leads')
