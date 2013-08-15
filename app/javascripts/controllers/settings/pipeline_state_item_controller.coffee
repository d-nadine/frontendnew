Radium.PipelineStateItemController = Radium.ObjectController.extend BufferedProxy,
  newChecklistItem: null
  account: Ember.computed.alias 'parentController.account'

  init: ->
    @_super.apply this, arguments
    @set 'newChecklistItem', Ember.Object.create
      isNewItem: true
      isEditing: true
      description: null
      weight: null
      kind: 'call'
      date: 1

  isFirstItem: (->
    return true if @get('account.isSaving')
    Ember.isEqual(this, @get('parentController.firstObject'))
  ).property('position', 'parentController.hasMultipleItems', 'account.isSaving')

  isLastItem: (->
    return true if @get('account.isSaving')

    Ember.isEqual(this, @get('parentController.lastObject'))
  ).property('position', 'parentController.hasMultipleItems', 'account.isSaving')

  resetNewItem: ->
    @get('newChecklistItem').setProperties
      description: null
      weight: null
      kind: 'Call'
      date: 1

  createChecklistItem: ->
    account = @get('account')

    return if account.get('isSaving')

    props = @get('newChecklistItem').getProperties('description', 'weight', 'kind', 'date')
    checklist = @get('model.checklist').createRecord props

    return unless account.get('isDirty')

    account.one 'didUpdate', =>
      @resetNewItem()
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
