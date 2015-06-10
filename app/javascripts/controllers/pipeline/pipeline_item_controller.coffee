Radium.PipelineItemController = Radium.ObjectController.extend Radium.ChecklistTotalMixin, BufferedProxy,
  Radium.ChangeDealStatusMixin,
  actions:
    deleteObject: (record) ->
      record.get('content').deleteRecord()

      @get('store').commit()

      @send "flashSuccess", "deleted!"

  needs: ['pipeline']
  workflowGroups: Ember.computed 'controllers.pipeline.model.workflowGroups.[]', ->
    @get('controllers.pipeline.workflowGroups')

  isCheckedDidChange: Ember.observer 'isChecked', ->
    @applyBufferedChanges()
