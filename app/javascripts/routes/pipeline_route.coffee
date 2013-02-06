Radium.PipelineRoute = Ember.Route.extend
  events:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group)
      @transitionTo 'pipeline.negotiating'

  model: ->
    Radium.Deal.all()

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons'
      into: 'drawer_panel'
      outlet: 'buttons'
