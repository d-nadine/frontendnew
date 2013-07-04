Radium.AccountSettingsController = Radium.ObjectController.extend
  checklistMap: Ember.Map.create()

  destroy: ->
    @get('checklistMap').destroy() if @get('checklistMap')
    @_super.apply this, arguments

  preStates: [
    'unpublished'
  ]

  postStates: [
    'closed'
    'lost'
  ]

  pipelineStateChecklists: ( ->
    checklistMap = @get('checklistMap')
    @get('workflow').forEach (state) =>
      checklistMap.set(state.get('name').toLowerCase(), state.get('checklist'))

    checklistMap
  ).property('workflow.[]')

  workflowStates: ( ->
    @get('workflow').map((state) =>
      state.get('name')
    ) || []
  ).property('workflow.[]')


  dealStates: (->
    @get('workflowStates').map (state) -> state.capitalize()
  ).property('workflowStates.[]')
