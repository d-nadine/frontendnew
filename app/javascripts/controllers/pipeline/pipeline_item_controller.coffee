Radium.PipelineItemController = Radium.ObjectController.extend Radium.ChecklistTotalMixin,
  deleteObject: (record) ->
    record.get('content').deleteRecord()

    @get('store').commit()

    @send "flashSuccess", "deleted!"
