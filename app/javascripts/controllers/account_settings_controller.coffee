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

  leadSources: ( ->
    return unless @get('model.leadSources')

    @get('model.leadSources')
  ).property('model.leadSources')

  pipelineStateChecklists: ( ->
    checklistMap = @get('checklistMap')
    @get('workflow').forEach (state) =>
      checklistMap.set(state.get('name').toLowerCase(), state.get('checklist'))

    checklistMap
  ).property('workflow.[]')

  workflowStates: ( ->
    Ember.A(@get('workflow').map((state) =>
      state.get('name')
    ) || [])
  ).property('workflow.[]')

  dealStates: (->
    statuses = @get('workflowStates').slice()
    statuses.pushObjects ['closed', 'lost'] unless statuses.contains 'closed'
    statuses
  ).property('workflowStates.[]')
