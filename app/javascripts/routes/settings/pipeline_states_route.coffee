Radium.SettingsPipelineStatesRoute = Radium.Route.extend
  events:
    confirmDeletion: (state) ->
      account = @controllerFor('account').get('model')

      if account.get('workflow.length') <= 2
        @send 'close'
        @send 'flashError', 'You must have at least 2 pipeline states'
        return

      @controllerFor('settingsConfirmPipelineStateDeletion').set('model', state)
      @render 'settings/confirm_pipeline_state_deletion',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: (state) ->
      account = @controllerFor('account').get('model')

      transaction = @get('store').transaction()

      transaction.add account

      state.deleteRecord()

      account.get('workflow').removeObject state

      transaction.commit()

      @send 'close'

  model: ->
    @controllerFor('account').get('workflow')
