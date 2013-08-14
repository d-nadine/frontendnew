Radium.PipelineChecklistItemController = Radium.ObjectController.extend BufferedProxy,
  account: Ember.computed.alias 'parentController.account'

  kinds: [
    "Todo"
    "Meeting"
    "Call"
  ]

  setKind: (kind) ->
    @set('kind', kind)

  edit:  ->
    @set('isEditing', true)

  save: ->
    return if @get('account.isSaving')

    @set('isEditing', false)

    @applyBufferedChanges()

    return unless @get('model.isDirty')

    @send 'saveState'

  cancel: (checklist) ->
    @discardBufferedChanges()
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
