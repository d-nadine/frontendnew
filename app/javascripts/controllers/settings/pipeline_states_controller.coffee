Radium.PipelineStateItemController = Ember.ObjectController.extend
  isFirstItem: (->
    Ember.isEqual(@, @get('parentController.firstObject'))
  ).property('position', 'parentController.hasMultipleItems')

  isLastItem: (->
    Ember.isEqual(@, @get('parentController.lastObject'))
  ).property('position', 'parentController.hasMultipleItems')

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

