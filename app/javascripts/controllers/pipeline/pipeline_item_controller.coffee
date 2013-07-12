Radium.PipelineItemController = Radium.ObjectController.extend
  deleteObject: (record) ->
    record.get('content').deleteRecord()

    @get('store').commit()

    Radium.Utils.notify "deleted!"
