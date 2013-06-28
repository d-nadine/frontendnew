Radium.PipelineStateItemController = Ember.ObjectController.extend
  newChecklistItem: null

  init: ->
    @_super()
    @createNewChecklistItem()

  createNewChecklistItem: ->
    @set 'newChecklistItem', Radium.NewChecklist.create
      isNewItem: true
      description: null
      weight: null
      kind: 'Call'

  isFirstItem: (->
    Ember.isEqual(@, @get('parentController.firstObject'))
  ).property('position', 'parentController.hasMultipleItems')

  isLastItem: (->
    Ember.isEqual(@, @get('parentController.lastObject'))
  ).property('position', 'parentController.hasMultipleItems')

  createChecklist: ->
    props = @get('newChecklistItem').getProperties('description', 'weight', 'kind', 'date')
    checklist = Radium.PipelineChecklist.createRecord(props)
    @get('checklists').pushObject(checklist)
    @store.commit()
    @get('newChecklistItem').setProperties
      description: null
      weight: null
      kind: 'Call'
      date: Ember.DateTime.create()

  deleteChecklist: (checklist) ->
    checklist.deleteRecord()
    @get('checklists').removeObject(checklist)
    @store.commit()



Radium.SettingsPipelineStatesController = Ember.ArrayController.extend
  itemController: 'pipelineStateItem'
  sortProperties: ['position']

  createPipelineState: ->
    Radium.PipelineState.createRecord
      name: "Untitled State"
      position: this.get('length') + 1

  deletePipelineState: (ps) ->
    ps.deleteRecord()
    @store.commit()

  hasMultipleItems: (->
    true if @get('length') > 1
  ).property('@each')

  movePipelineStateUp: (ps) ->
    idx = @get('arrangedContent').indexOf(ps)

    false if Ember.isEqual(ps, @get('content.firstObject'))

    @objectAt(idx - 1).incrementProperty('position')
    ps.decrementProperty('position')
    @store.commit()

  movePipelineStateDown: (ps) ->
    idx = @get('arrangedContent').indexOf(ps)

    false if Ember.isEqual(ps, @get('content.lastObject'))

    @objectAt(idx + 1).decrementProperty('position')
    ps.incrementProperty('position')
    @store.commit()

