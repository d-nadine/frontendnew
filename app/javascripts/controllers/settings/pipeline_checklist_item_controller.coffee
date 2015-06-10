Radium.PipelineChecklistItemController = Radium.ObjectController.extend BufferedProxy,
  actions:
    setKind: (kind) ->
      @set('kind', kind)

    setDate: (date) ->
      @set('content.date', date)

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

  selectedDateString: Ember.computed 'content.date', ->
    date = @get('content.date')

    switch date
      when 0 then dateString = "Right away"
      when 1 then dateString = "1 Day"
      when 2 then dateString = "2 Days"
      when 7 then dateString = "1 Week"

    dateString

  account: Ember.computed.alias 'parentController.account'

  kinds: [
    "todo"
    "meeting"
  ]

  isValid: Ember.computed 'description', 'weight', 'kind', 'date', ->
    model = @get('model')

    return unless model
    return false if Ember.isEmpty model.get('description')
    return false unless model.get('weight')

    true
