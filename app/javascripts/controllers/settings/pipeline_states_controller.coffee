Radium.SettingsPipelineStatesController = Radium.ArrayController.extend
  actions:
    saveState: ->
      account = @get('account')

      return unless account.get('isDirty')
      return if @get('account.isSaving')

      account.one 'didUpdate', =>
        @send 'flashSuccess', 'Updated'

      account.one 'becameInvalid', (result) =>
        @send 'flashError', result
        account.reset()

      account.one 'becameError', (result) =>
        @send 'flashError', 'An error occurred and the action can not be completed'
        result.reset()

      @get('store').commit()

    createPipelineState: ->
      newPosition = @get('length') + 1

      @get('account.workflow').createRecord
                                name: "Pipeline State #{newPosition}"
                                position: newPosition
      @send 'saveState'

    movePipelineStateUp: (state) ->
      states = @map (item) -> item.get('model')

      index = states.indexOf state

      return false if index == 0

      next = states.objectAt(index - 1)

      return unless next

      state.set('position', index)
      next.set('position', index + 1)

      @send 'saveState'

    movePipelineStateDown: (state) ->
      states = @map (item) -> item.get('model')

      index = states.indexOf state

      return false if index == (@get('length') - 1)

      next = states.objectAt(index + 1)

      return unless next

      state.set('position', index + 2)
      next.set('position', index + 1)

      @send 'saveState'

  sortProperties: ['position']
  needs: ['account']
  account: Ember.computed.alias 'controllers.account.model'

  itemController: 'pipelineStateItem'

  hasMultipleItems: (->
    true if @get('length') > 1
  ).property('@each')
