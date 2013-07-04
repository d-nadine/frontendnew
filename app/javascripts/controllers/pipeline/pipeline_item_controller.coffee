Radium.PipelineItemController = Radium.ObjectController.extend
  # isChecked: false
  deleteObject: (record) ->
    record.get('content').deleteRecord()

    @get('store').commit()

    Radium.Utils.notify "deleted!"
