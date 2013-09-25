Radium.PipelineRoute = Radium.Route.extend Radium.ChecklistEvents, Radium.DealStatusChangeMixin,
  actions:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.index'

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
