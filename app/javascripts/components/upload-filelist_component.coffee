Radium.UploadFilelistComponent = Ember.Component.extend
  actions:
    removeFile: (file) ->
      attachment = @get('file.attachment')
      @get('files').removeObject(file)

      # FIXME: server side delete
      # attachment.deleteRecord()

      # attachment.get('transaction').commit()

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
