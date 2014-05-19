require 'mixins/views/uploading_mixin'

Radium.FileUploaderComponent = Ember.TextField.extend Radium.UploadingMixin,
  classNames: ['upload-button']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: true

  store: Ember.computed ->
    this.container.lookup "store:main"

  change: (e) ->
    files = e.target.files
    return if Ember.isEmpty(files)

    @uploadFiles files
