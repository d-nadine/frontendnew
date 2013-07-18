Radium.PipelineRoute = Radium.Route.extend
  events:
    selectGroup: (group) ->
      @controllerFor('pipeline').set('selectedGroup', group.get('title'))
      @transitionTo 'pipeline.index'

    showChecklist: (deal) ->
      @controllerFor('dealChecklist').set('model', deal)
      @render 'deal/checklist',
        into: 'application'
        outlet: 'modal'

    saveChecklist: (deal) ->
      deal.one 'becameInvalid', =>
        Radium.Utils.generateErrorSummary deal

      deal.one 'becameError', =>
        Radium.Utils.notifyError 'An error has occurred and the eamil has not been sent'

      @get('store').commit()
      @send 'close'

    cancelChecklistSave: (model)->
      model.get('transaction').rollback()
      @send 'close'

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
