Radium.ChecklistMixin = Ember.Mixin.create
  createNewItem: ->
    description = @get('newItemDescription')
    weight = parseInt(@get('newItemWeight'))
    finished = @get('newItemFinished')
    return if Ember.isEmpty(description)
    return if Ember.isEmpty(weight)

    newItem =
            description: description
            weight: weight
            isFinished: true
            kind: 'additional'

    newRecord = if @get('isNew')
                  Ember.Object.create(newItem)
                else
                  @get('forecast').createRecord(newItem)

    if @get('isNew')
      @get('forecast').addObject newRecord

    @set('newItemDescription', '')
    @set('newItemWeight', '')
    @set('newItemFinished',false)

