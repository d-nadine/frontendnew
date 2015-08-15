Radium.PipelineItemController = Radium.ObjectController.extend Radium.ChecklistTotalMixin, BufferedProxy,
  Radium.ChangeDealStatusMixin,
  actions:
    deleteObject: (record) ->
      record.get('content').deleteRecord()

      @get('store').commit()

      @send "flashSuccess", "deleted!"

      false

    confirmSingleDelete: ->
      @set "showDeleteConfirmation", true

      false

    deleteDeal: ->
      @send 'deleteRecord', @get('model')

      false

  needs: ['pipeline']
  workflowGroups: Ember.computed 'controllers.pipeline.model.workflowGroups.[]', ->
    @get('controllers.pipeline.workflowGroups')

  isCheckedDidChange: Ember.observer 'isChecked', ->
    @applyBufferedChanges()

  showDeleteConfirmation: false
