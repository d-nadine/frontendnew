Radium.PipelineItemController = Radium.ObjectController.extend Radium.ChecklistTotalMixin, BufferedProxy,
  Radium.ChangeDealStatusMixin,
  actions:
    deleteObject: (record) ->
      record.get('content').deleteRecord()

      @get('store').commit()

      @send "flashSuccess", "deleted!"

  needs: ['pipeline']
  workflowGroups: ( ->
    @get('controllers.pipeline.workflowGroups')
  ).property('controllers.pipeline.model.workflowGroups.[]')

  isCheckedDidChange: ( ->
    @applyBufferedChanges()
  ).observes('isChecked')
