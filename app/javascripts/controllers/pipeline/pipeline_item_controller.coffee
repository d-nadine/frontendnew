Radium.PipelineItemController = Radium.ObjectController.extend Radium.ChecklistTotalMixin,
  deleteObject: (record) ->
    record.get('content').deleteRecord()

    @get('store').commit()

    Radium.Utils.notify "deleted!"
