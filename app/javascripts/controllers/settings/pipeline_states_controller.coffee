Radium.SettingsPipelineStatesController = Ember.ArrayController.extend
  sortProperties: ['position']
  needs: ['account']
  account: Ember.computed.alias 'controllers.account.model'

  itemController: 'pipelineStateItem'

  saveState: ->
    account = @get('account')
    return unless account.get('isDirty')

    account.one 'didUpdate', =>
      @send 'flashSuccess', 'Updated'

    account.one 'becameInvalid', (result) =>
      @send 'flashError', result

    account.one 'becameError', (result) =>
      @send 'flashError', 'An error occurred and the action can not be completed'

    @get('store').commit()

  createPipelineState: ->
    newState = Radium.PipelineState.createRecord
      name: "Pipeline State #{this.get('length') + 1}"
      position: @get('length') + 1

    newState.one('didCreate', ->
      newState.set('isNewItem', true)
    )

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

