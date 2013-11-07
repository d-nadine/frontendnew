require 'mixins/routes/bulk_action_events_mixin'

Radium.PipelineOpendealsRoute = Em.Route.extend Radium.BulkActionEmailEventsMixin,
  actions:
    deleteRecord: (deal) ->
      updatedModel = @controller.get('model').slice().reject (d) -> d == deal
      @controller.set("model", updatedModel)
      @_super deal

  model: ->
    if controller = @controllerFor 'pipelineOpendeals'
      if controller.get('filteredDeals.length')
        model = controller.get('filteredDeals').slice()

        Ember.run.next =>
          controller.set 'filteredDeals', null

        model
