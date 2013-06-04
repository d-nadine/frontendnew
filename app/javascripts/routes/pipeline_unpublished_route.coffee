require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineUnpublishedRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin, 
  model: ->
    @modelFor('pipeline').get('unpublished')
