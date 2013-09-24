Radium.PipelineRoute = Radium.Route.extend
  actions:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.index'

  activate: ->
    @_super.apply this, arguments
    unless @actions.hasOwnProperty 'saveChecklist'
      Ember.merge @actions, Radium.ChecklistEvents

    unless @actions.hasOwnProperty 'showStatusChangeConfirm'
      Ember.merge @actions, Radium.DealStatusChangeMixin

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
