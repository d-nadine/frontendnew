Radium.PipelineStateItemController = Radium.ObjectController.extend BufferedProxy,
  actions:
    resetNewItem: ->
      @get('newChecklistItem').setProperties
        description: null
        weight: null
        kind: 'Todo'
        date: 1

    createChecklistItem: ->
      account = @get('account')

      return if account.get('isSaving')

      weight = @get('newChecklistItem.weight') || 0

      if isNaN(weight) || parseInt(weight) <= 0 || parseInt(weight) > 100
        return @send 'flashError', 'The weight of the pipeline state must be numeric and greater than 100'

      props = @get('newChecklistItem').getProperties('description', 'weight', 'kind', 'date')
      checklist = @get('model.checklist').createRecord props

      return unless account.get('isDirty')

      account.save().then (result) =>
        @send 'resetNewItem'
        @send 'flashSuccess', 'Updated'

    deleteChecklistItem: (checklistItem) ->
      checklistItem.deleteRecord()
      @send 'saveState'

  newChecklistItem: null
  account: Ember.computed.alias 'parentController.account'

  init: ->
    @_super.apply this, arguments
    @set 'newChecklistItem', Ember.Object.create
      isNewItem: true
      isEditing: true
      description: null
      weight: null
      kind: 'todo'
      date: 1

  isFirstItem: Ember.computed 'position', 'parentController.hasMultipleItems', 'account.isSaving', ->
    return true if @get('account.isSaving')
    Ember.isEqual(this, @get('parentController.firstObject'))

  isLastItem: Ember.computed 'position', 'parentController.hasMultipleItems', 'account.isSaving', ->
    return true if @get('account.isSaving')

    Ember.isEqual(this, @get('parentController.lastObject'))
