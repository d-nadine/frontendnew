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
    return [] unless @get('workflow.length')

    states = (@get('workflow').toArray().sort((a, b) ->
        Ember.compare a.get('position'), b.get('position')
      ).map((state) =>
        state.get('name')
      )
    )

    return Ember.A(states)
  ).property('workflow.[]', 'workflow.@each.position')

  dealStates: (->
    statuses = @get('workflowStates').slice()
    statuses.pushObjects ['closed', 'lost'] unless statuses.contains 'closed'
    statuses
  ).property('workflowStates.[]')

  firstState: ( ->
    dealStates = @get('dealStates')
    Ember.assert 'There are dealStates', dealStates.get('length')
    dealStates.get('firstObject')
  ).property('workflowStates.[]')


