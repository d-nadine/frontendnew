Radium.ChecklistEvents = 
  showChecklist: (deal) ->
    @controllerFor('dealChecklist').set('model', deal)
    @render 'deal/checklist',
      into: 'application'
      outlet: 'modal'

  saveChecklist: (deal) ->
    deal.one 'becameInvalid', =>
      @send 'flashError', deal
      deal.reset()

    deal.one 'becameError', =>
      @send 'flashError', 'The checklist item could not be created'
      deal.reset()

    @get('store').commit()
    @send 'close'

  cancelChecklistSave: (model)->
    model.get('transaction').rollback()
    @send 'close'
