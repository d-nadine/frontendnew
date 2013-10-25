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

  handlerFactory: (wrappedFile) ->
    (data) =>
      id = data["attachment"]["id"]
      store = @get("controller.store")
      adapter = store.adapterForType(Radium.Attachment)
      adapter.didFindRecord(store, Radium.Attachment, data, id)
      attachment = Radium.Attachment.find(id)
      wrappedFile.set 'isUploading', false
      wrappedFile.set 'attachment', attachment

      isUploading = @get('files').any (file) -> file.get('isUploading')
      @set('disableSave', isUploading)

  change: (e) ->
    files = e.target.files
    return if Ember.isEmpty(files)

    @set('disableSave', true)
    uploader = @get('uploader')
    uploadToFiles = @get('files')

    for i in [0...files.length]
      file = files[i]
      wrappedFile = Ember.Object.create(file, file: file, isUploading: true)

      uploadToFiles.pushObject(wrappedFile)

      uploader.upload(file).then @handlerFactory(wrappedFile).bind(this)

    false
