require 'routes/mixins/email_events_mixin'

Radium.PipelineLeadsRoute = Em.Route.extend Radium.EmailEventsMixin,
  model: ->
    @modelFor('pipeline').get('leads')
