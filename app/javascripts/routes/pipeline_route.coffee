Radium.PipelineRoute = Ember.Route.extend
  events:
    showCustomStatus: (status) ->
      @controllerFor('pipeline').set('currentStatus', status)
      @transitionTo 'pipeline.negotiating'

  model: ->
    Radium.Deal.all()

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons'
      into: 'drawer_panel'
      outlet: 'buttons'
