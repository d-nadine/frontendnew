Radium.PipelineChecklistItemController = Ember.ObjectController.extend
  kinds: [
    "Todo"
    "Meeting"
    "Call"
  ]

  setKind: (kind) ->
    @set('kind', kind)

  edit: (checklist) ->
    transaction = @store.transaction()
    transaction.add(checklist)
    @set('isEditing', true)

  save: (checklist) ->
    checklist.get('transaction').commit()
    @set('isEditing', false)

  cancel: (checklist) ->
    @get('content.transaction').rollback()
    @set('isEditing', false)