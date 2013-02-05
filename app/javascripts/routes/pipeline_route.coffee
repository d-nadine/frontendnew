Radium.PipelineRoute = Ember.Route.extend
  events:
    showCustomStatus: (status)->
      console.log status.get('status')

  model: ->
    Radium.Deal.all()

  renderTemplate: ->
    @render into: 'application'

    @render 'pipeline/drawer_buttons'
      into: 'drawer_panel'
      outlet: 'buttons'
