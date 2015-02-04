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

      props = @get('newChecklistItem').getProperties('description', 'weight', 'kind', 'date')
      checklist = @get('model.checklist').createRecord props

      return unless account.get('isDirty')

      account.one 'didUpdate', =>
        @send 'resetNewItem'
        @send 'flashSuccess', 'Updated'

      account.one 'becameInvalid', (result) =>
        @send 'flashError', result
        result.reset()

      account.one 'becameError', (result) =>
        @send 'flashError', 'An error occurred and the action can not be completed'
        result.reset()

      @get('store').commit()

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
