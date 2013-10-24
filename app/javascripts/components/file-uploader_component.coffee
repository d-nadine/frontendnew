require 'mixins/views/uploading_mixin'

Radium.FileUploaderComponent = Ember.TextField.extend Radium.UploadingMixin,
  classNames: ['upload-button']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: true

  init: ->
    @_super.apply this, arguments
    # FIXME: Total hack, remove when the initializer works
    @set 'controller.store', Radium.__container__.lookup('store:main')

  change: (e) ->
    files = e.target.files
    return if Ember.isEmpty(files)
    uploader = @get('uploader')
    uploadToFiles = @get('files')

    for i in [0...files.length]
      file = files[i]
      fileWrapper = Ember.Object.create(file, file: file, isUploading: true)
      uploadToFiles.pushObject(fileWrapper)
      uploader.upload(file)

    false

  onDidUpload: (data) ->
    id = data["attachment"]["id"]
    store = @get("controller.store")
    adapter = store.adapterForType(Radium.Attachment)
    adapter.didFindRecord(store, Radium.Attachment, data, id)
    attachment = Radium.Attachment.find(id)
