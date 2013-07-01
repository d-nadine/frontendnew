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

  selectedDateString: (->
    date = @get('content.date')

    switch date
      when 0 then dateString = "Right away"
      when 1 then dateString = "1 Day"
      when 2 then dateString = "2 Days"
      when 7 then dateString = "1 Week"

    dateString
  ).property('content.date')

  setNone: ->
    @set('content.date', 0)

  setOneDay: ->
    @set('content.date', 1)

  setTwoDays: ->
    @set('content.date', 2)

  setOneWeek: ->
    @set('content.date', 7)