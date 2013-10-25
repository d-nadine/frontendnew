Radium.UploadFilelistComponent = Ember.Component.extend
  actions:
    removeFile: (file) ->
      attachment = @get('file.attachment')
      @get('files').removeObject(file)

      # FIXME: server side delete
      # attachment.deleteRecord()

      # attachment.get('transaction').commit()
