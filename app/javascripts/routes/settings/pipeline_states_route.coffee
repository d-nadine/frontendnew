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
      state.deleteRecord()

      @controllerFor('account').get('workflow').removeObject state

      @store.commit()

      @send 'close'

  model: ->
    @controllerFor('account').get('workflow')
