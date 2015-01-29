require 'mixins/views/uploading_mixin'

Radium.FileUploaderComponent = Ember.TextField.extend Radium.UploadingMixin,
  classNames: ['upload-button']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: true

  change: (e) ->
    files = e.target.files
    return if Ember.isEmpty(files)

    @uploadFiles files
