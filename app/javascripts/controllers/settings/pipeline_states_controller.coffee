Radium.SettingsPipelineStatesController = Ember.ArrayController.extend
  sortProperties: ['position']
  needs: ['account']
  account: Ember.computed.alias 'controllers.account.model'

  itemController: 'pipelineStateItem'

  saveState: ->
    debugger
    account = @get('account')
    return unless account.get('isDirty')

    account.one 'didUpdate', =>
      @send 'flashSuccess', 'Updated'

    account.one 'becameInvalid', (result) =>
      debugger
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

  movePipelineStateUp: (state) ->
    position = state.get('position')

    return false if position == 1

    previous = @find (ps) -> ps.position == (position - 1)

    return unless next

    previous.incrementProperty('position')
    state.decrementProperty('position')

    @saveState()

  movePipelineStateDown: (ps) ->
    position = state.get('position')

    return false if position == @get('length') - 1

    next = @find (ps) -> ps.position == (position + 1)

    return unless next

    next.decrementProperty('position')
    state.incrementProperty('position')

    @saveState()
