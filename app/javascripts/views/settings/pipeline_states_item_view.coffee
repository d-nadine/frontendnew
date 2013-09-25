Radium.PipelineStatesItemView = Ember.View.extend
  classNames: ["row", "pipeline-state-item"]
  templateName: 'settings/pipeline_states_item'

  pipelineStateName: Ember.TextField.extend Ember.TargetActionSupport,
    valueBinding: 'targetObject.model.name'
    disabledBinding: 'targetObject.account.isSaving'
    action: 'saveState'
    target: 'controller'
    insertNewline: (e) ->
      @triggerAction()
      e.stopPropagation()
      e.preventDefault()

  didInsertElement: ->
    if @get('content.isNew')
      @$().addClass('new')
      @$()[0].offsetWidth
      @$().addClass('out')
      @$('.inline-field').focus()
