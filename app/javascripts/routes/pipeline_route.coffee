Radium.PipelineRoute = Ember.Route.extend
  events:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group)
      @transitionTo 'pipeline.negotiating'

  model: ->
    Radium.Pipeline.create
      content: Radium.Deal.all(),
      settings: @controllerFor('settings')

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons',
      outlet: 'buttons'
      into: 'application'
