Radium.ChecklistMixin = Ember.Mixin.create
  kinds: [
    "todo"
    "meeting"
    "call"
  ]
  dateMap: Ember.Map.create()
  init: ->
    @_super.apply this, arguments
    dateMap = @get 'dateMap'
    dateMap.set(0, 'Right away')
    dateMap.set(1, '1 Day')
    dateMap.set(2, 'Days')
    dateMap.set(7, '1 Week')

  selectedDateText: ( ->
    @get('dateMap').get(@get('newItemDate'))
  ).property('newItemDate')

  setItemDate: (date) ->
    @set 'newItemDate', date

  setKind: (kind) ->
    @set 'newItemKind', kind.toLowerCase()

  createNewItem: ->
    description = @get('newItemDescription')
    weight = parseInt(@get('newItemWeight'))
    finished = @get('newItemFinished')
    date = @get('newItemDate')
    kind = @get('newItemKind')

    return if Ember.isEmpty(description)
    return if Ember.isEmpty(weight)

    newItem =
            description: description
            weight: weight
            isFinished: false
            isAdditional: true 
            kind: kind
            date: date

    newRecord = if @get('isNew')
                  Ember.Object.create(newItem)
                else
                  @get('checklist').createRecord(newItem)

    if @get('isNew')
      @get('checklist').addObject newRecord
    else
      @get('store').commit()

    @set('newItemDescription', '')
    @set('newItemWeight', '')
    @set('newItemFinished', false)
    @set('newItemDate', 0)
    @set('newItemKind', 'todo')
