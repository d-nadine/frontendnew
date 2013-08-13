Radium.PipelineStateItemController = Radium.ObjectController.extend BufferedProxy,
  newChecklistItem: null
  account: Ember.computed.alias 'parentController.account'

  init: ->
    @_super()
    @createNewChecklistItem()

  createNewChecklistItem: ->
    @set 'newChecklistItem', Radium.NewChecklist.create
      isNewItem: true
      description: null
      weight: null
      kind: 'Call'
      date: 1

  isFirstItem: (->
    return if @get('account.isSaving')
    Ember.isEqual(@, @get('parentController.firstObject'))
  ).property('position', 'parentController.hasMultipleItems', 'account.isSaving')

  isLastItem: (->
    return if @get('account.isSaving')

    Ember.isEqual(@, @get('parentController.lastObject'))
  ).property('position', 'parentController.hasMultipleItems', 'account.isSaving')

  createChecklist: ->
    props = @get('newChecklistItem').getProperties('description', 'weight', 'kind', 'date')
    checklist = Radium.PipelineChecklist.createRecord(props)

    @get('newChecklistItem').setProperties
      description: null
      weight: null
      kind: 'Call'
      date: 1

    checklist.one('didCreate', =>
      # Hack, since for some reason `isNew` this gets turned off once the object
      # is pushed into a parent model, forcing a redraw. Could be a better approach
      checklist.set('isNewItem', true)
      @get('checklists').pushObject(checklist)
    )

    @store.commit()

  deleteChecklist: (checklist) ->
    checklist.deleteRecord()
    @get('checklists').removeObject(checklist)
    @store.commit()
