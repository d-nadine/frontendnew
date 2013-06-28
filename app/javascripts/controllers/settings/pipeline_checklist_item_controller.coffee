Radium.PipelineChecklistItemController = Ember.ObjectController.extend
  kinds: [
    "Todo"
    "Meeting"
    "Call"
  ]

  setKind: (kind) ->
    @set('kind', kind)