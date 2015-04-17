Radium.UploadFilelistComponent = Ember.Component.extend
  actions:
    removeFile: (file) ->
      @get('files').removeObject(file)

      attachment = if file instanceof Radium.Attachment
                     file
                   else
                     file.get('attachment')

      attachment.deleteRecord()

      attachment.get('transaction').commit()

      false

  classNameBindings: [':attachment']

  hideUploadedBy: false
