Radium.ChecklistMixin = Ember.Mixin.create Ember.Evented,
  actions:
    removeAdditionalItem: (item) ->
      @get('checklist').removeObject item

      @get("store").commit()

    setItemDate: (date) ->
      @set 'newItemDate', date

    setKind: (kind) ->
      @set 'newItemKind', kind.toLowerCase()

    createNewItem: ->
      @set 'newItemSubmitted', true
      description = @get('newItemDescription')
      weight = parseInt(@get('newItemWeight'))
      finished = @get('newItemFinished')
      date = @get('newItemDate') || 0
      kind = @get('newItemKind') || 'todo'

      return unless @get('isChecklistItemValid')

      newItem =
              description: description
              weight: weight
              isFinished: false
              isAdditional: true
              kind: kind
              date: date

      checklistItem = if @get('isNew')
                    Ember.Object.create(newItem)
                  else
                    @get('checklist').createRecord(newItem)

      didCommit = (result) =>
        @send 'reset'
        @trigger 'newItemCreated'

      if @get('isNew')
        @get('checklist').addObject checklistItem
      else
        checklistItem.one 'didCreate', didCommit
        checklistItem.one 'didUpdate', didCommit

        @get('store').commit()

      @send 'reset'
      false

    reset: ->
      @set 'newItemSubmitted', false
      @set('newItemDescription', '')
      @set('newItemWeight', '')
      @set('newItemFinished', false)
      @set('newItemDate', 0)
      @set('newItemKind', 'todo')

  kinds: Ember.A([
    "todo"
    "meeting"
    # "call"
  ])

  isChecklistItemValid: Ember.computed 'newItemDescription', 'newItemWeight', 'newItemSubmitted', ->
    !Ember.isEmpty(@get('newItemDescription')) && !Ember.isEmpty(@get('newItemWeight'))

  newItemSubmitted: false

  dateMap: Ember.Map.create()

  init: ->
    @_super.apply this, arguments
    dateMap = @get 'dateMap'
    dateMap.set(0, 'Right away')
    dateMap.set(1, '1 Day')
    dateMap.set(2, 'Days')
    dateMap.set(7, '1 Week')
    @send 'reset'

  selectedDateText: Ember.computed 'newItemDate', ->
    @get('dateMap').get(@get('newItemDate'))
