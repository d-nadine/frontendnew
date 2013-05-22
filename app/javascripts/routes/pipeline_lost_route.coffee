require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineLostRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin, 
  model: ->
    @modelFor('pipeline').get('lost')
