require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineLeadsRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin,
  model: ->
    if @controller && @controller.get('filteredLeads.length')
      model = @controller.get('filteredLeads').slice()

      Ember.run.next =>
        @controller.set 'filteredLeads', null

      return model

    @modelFor('pipeline').get('leads')
