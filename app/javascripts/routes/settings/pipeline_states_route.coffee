Radium.SettingsPipelineStatesRoute = Radium.Route.extend
  events:
    confirmDeletion: (state) ->
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

      workflowState = account.get('workflow').find (ps) =>
        ps == state

      workflowState.deleteRecord()

      account.get('workflow').removeObject workflowState

      @store.commit()

      @send 'close'

  model: ->
    @controllerFor('account').get('workflow')
