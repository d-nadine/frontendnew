Radium.PipelineRoute = Radium.Route.extend Radium.ChecklistEvents, Radium.DealStatusChangeMixin,
  actions:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.index'

    resetFilters: ->
      @controllerFor("pipeline").setProperties
        searchText: ""
        filterStartDate: null
        filterEndDate: null

  deactivate: ->
    @_super.apply this, arguments
    @send "resetFilters"

  model: ->
    model = @modelFor 'pipeline'

    return model if model

    Radium.Pipeline.create
      settings: @controllerFor('accountSettings')
