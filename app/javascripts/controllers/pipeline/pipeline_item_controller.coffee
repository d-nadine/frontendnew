Radium.PipelineItemController = Radium.ObjectController.extend Radium.ChecklistTotalMixin, BufferedProxy,
  needs: ['pipeline']
  workflowGroups: ( ->
    @get('controllers.pipeline.workflowGroups')
  ).property('controllers.pipeline.model.workflowGroups.[]')

  isCheckedDidChange: ( ->
    @applyBufferedChanges()
  ).observes('isChecked')

  changeStatus: (status) ->
    @discardBufferedChanges()

    return if status == @get('status')

    commit =  =>
      if status == 'lost'
        @set 'lostDuring', @get('model.status')
      @applyBufferedChanges()
      @get('store').commit()

    @set 'status', status

    @send 'showStatusChangeConfirm', this, commit

  deleteObject: (record) ->
    record.get('content').deleteRecord()

    @get('store').commit()

    @send "flashSuccess", "deleted!"
