Radium.PipelineRoute = Radium.Route.extend
  events:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.negotiating'

  model: ->
    Radium.Pipeline.create
      settings: @controllerFor('accountSettings')

  deactivate: ->
    model = @controllerFor('pipeline').get('model')
    model.destroy()
    model = null
    @currentModel = null

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons',
      outlet: 'buttons'
      into: 'application'
