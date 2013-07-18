Radium.ChecklistEvents = 
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
