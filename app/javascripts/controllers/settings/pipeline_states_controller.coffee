Radium.SettingsPipelineStatesController = Ember.ArrayController.extend
  sortProperties: ['position']
  needs: ['account']
  account: Ember.computed.alias 'controllers.account.model'

  itemController: 'pipelineStateItem'

  saveState: ->
    account = @get('account')

    return unless account.get('isDirty')
    return if @get('account.isSaving')

    account.one 'didUpdate', =>
      @send 'flashSuccess', 'Updated'

    account.one 'becameInvalid', (result) =>
      @send 'flashError', result

    account.one 'becameError', (result) =>
      @send 'flashError', 'An error occurred and the action can not be completed'

    @get('store').commit()

  createPipelineState: ->
    newPosition = @get('length') + 1

    @get('account.workflow').createRecord
                              name: "Pipelie State #{newPosition}"
                              position: newPosition
    @saveState()

  deletePipelineState: (ps) ->
    ps.deleteRecord()
    @store.commit()

  hasMultipleItems: (->
    true if @get('length') > 1
  ).property('@each')

  movePipelineStateUp: (state) ->
    position = state.get('position')

    return false if position == 1

    previous = @find (ps) -> ps.get('position') == (position - 1)

    return unless previous

    previous.get('model').incrementProperty('position')
    state.decrementProperty('position')

    @saveState()

  movePipelineStateDown: (state) ->
    position = state.get('position')

    return false if position == @get('length')

    next = @find (ps) -> ps.get('position') == (position + 1)

    return unless next

    next.get('model').decrementProperty('position')
    state.incrementProperty('position')

    @saveState()
