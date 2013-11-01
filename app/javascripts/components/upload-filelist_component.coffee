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

Radium.AttachmentListController = Ember.ObjectController.extend
  isLoaded: Ember.computed.alias 'model.attachment.isLoaded'
  isUploading: Ember.computed.alias 'model.attachment.isUploading'
  isLoading: ( ->
    (not @get('isLoaded')) || @get('isUploading')
  ).property('isLoaded', 'isUploading')
  fileName: ( ->
    return "#{@get('name')} (#{@get('size')})" if @get('name')

    @get('attachment.fileName')
  ).property('name', 'attachment', 'isLoaded')
