require 'lib/radium/ember-uploader'

Radium.UploadingMixin = Ember.Mixin.create
  percentage: 0

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    url = "#{@get('controller.store._adapter.url')}/uploads"
    @setUploader(url)

  setUploader: (url) ->
    @set('uploader', Ember.Uploader.create
                        url: url,
                        model: @get('controller.model'))

    @get('uploader').on('didUpload', this, 'onDidUpload')
    @get('uploader').on('progress', this, 'onDidProgress')
    @get('uploader')

  uploadFiles: (files) ->
    @set('disableSave', true)
    uploader = @get('uploader')
    uploadToFiles = @get('files')

    for i in [0...files.length]
      file = files[i]
      wrappedFile = Ember.Object.create(file, file: file, isUploading: true)

      uploadToFiles.pushObject(wrappedFile)

      model = @get('model')

      hash = if model?.humanize
                type: model.humanize(), id: model.get('id')
              else
                bucket: @get('bucket')

      uploader.upload(file, hash).then @handlerFactory(wrappedFile).bind(this)

    false

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

  onDidUpload: (data) ->
    setTimeout =>
      @set 'percentage', 0
    , 200
    @get('controller.model').reload()

  onDidProgress: (percent) ->
    @set('percentage', percent)

  isUploadingDidChange: Ember.observer 'uploader.isUploading', ->
    @set('percentage', 1)
