Radium.PipelineRoute = Radium.Route.extend Radium.ChecklistEvents, Radium.DealStatusChangeMixin,
  actions:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.index'

    resetFilters: ->
      # FIXME: There must be a better way to reset this field, but I don't yet know one.
      Ember.run.later -> 
        $("input.daterange-field").val("")
      @controllerFor("pipeline").setProperties
        searchText: ""
        filterStartDate: null
        filterEndDate: null

    # When transitioning between tabs, reset the filters so they don't carry over
    willTransition: ->
      @send "resetFilters"
      return true

  model: ->
    model = @modelFor 'pipeline'

    return model if model

    Radium.Pipeline.create
      settings: @controllerFor('accountSettings')

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons',
      outlet: 'buttons'
      into: 'application'
