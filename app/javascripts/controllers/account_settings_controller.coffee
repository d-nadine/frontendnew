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

  leadSources: Ember.computed 'model.leadSources', ->
    return unless @get('model.leadSources')

    @get('model.leadSources')

  pipelineStateChecklists: Ember.computed 'workflow.[]', ->
    checklistMap = @get('checklistMap')
    @get('workflow').forEach (state) ->
      checklistMap.set(state.get('name').toLowerCase(), state.get('checklist'))

    checklistMap

  workflowStates: Ember.computed 'workflow.[]', 'workflow.@each.position', ->
    return [] unless @get('workflow.length')

    states = (@get('workflow').toArray().sort((a, b) ->
        Ember.compare a.get('position'), b.get('position')
      ).map((state) ->
        state.get('name')
      )
    )

    Ember.A(states)

  dealStates: Ember.computed 'workflowStates.[]', ->
    statuses = @get('workflowStates').slice()
    statuses.pushObjects ['closed', 'lost'] unless statuses.contains 'closed'
    statuses

  firstState: Ember.computed 'workflowStates.[]', ->
    dealStates = @get('dealStates')
    Ember.assert 'There are dealStates', dealStates.get('length')
    dealStates.get('firstObject')
