Radium.PipelineRoute = Radium.Route.extend
  events:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.index'

  activate: ->
    @_super.apply this, arguments

    @_super.apply this, arguments
    unless @events.hasOwnProperty 'saveChecklist'
      Ember.merge @events, Radium.ChecklistEvents

    unless @events.hasOwnProperty 'showStatusChangeConfirm'
      Ember.merge @events, Radium.DealStatusChangeMixin

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
