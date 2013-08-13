Radium.PipelineStatesItemView = Ember.View.extend
  classNames: ["row", "pipeline-state-item"]
  templateName: 'settings/pipeline_states_item'

  pipelineStateName: Ember.TextField.extend Ember.TargetActionSupport,
    valueBinding: 'controller.model.name'
    disabledBinding: 'controller.account.isSaving'
    action: 'saveState'
    target: 'controller'
    insertNewline: ->
      @triggerAction()
      false

  didInsertElement: ->
    if @get('content.isNew')
      @$().addClass('new')
      @$()[0].offsetWidth
      @$().addClass('out')
      @$('.inline-field').focus()
