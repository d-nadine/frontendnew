Radium.UploadFilelistComponent = Ember.Component.extend
  actions:
    removeFile: (file) ->
      @get('files').removeObject(file)

      attachment = if file instanceof Radium.Attachment
                     file
                   else
                     file.get('attachment')

      attachment.delete()

      false

  classNameBindings: [':attachment']

  hideUploadedBy: false
