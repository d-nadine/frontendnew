require 'lib/radium/ember-uploader'

Radium.UploadingMixin = Ember.Mixin.create
  percentage: 0
  didInsertElement: ->
    @_super.apply this, arguments
    url = "#{@get('controller.store._adapter.url')}/uploads"
    @set('uploader', Ember.Uploader.create
                        url: url,
                        model: @get('controller.model'),
    )

    @get('uploader').on('didUpload', this, 'onDidUpload')
    @get('uploader').on('progress', this, 'onDidProgress')

  fileUploader: Ember.FileField.extend
    change: (e) ->
      files = e.target.files
      return unless files.length
      uploader = @get('parentView.uploader')
      model = @get('parentView.controller.model')
      modelAttributes = type: model.humanize(), id: model.get('id')
      for file in files
        uploader.upload(file, modelAttributes).then (data) =>
          @get('parentView').onDidUpload(data)

  uploadFiles: (files) ->
    @set('disableSave', true)
    uploader = @get('uploader')
    uploadToFiles = @get('files')

    for i in [0...files.length]
      file = files[i]
      wrappedFile = Ember.Object.create(file, file: file, isUploading: true)

      uploadToFiles.pushObject(wrappedFile)

      uploader.upload(file, bucket: @get('bucket')).then @handlerFactory(wrappedFile).bind(this)

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

  isUploadingDidChange: (->
    return unless @get('uploader.isUploading')
    @set('percentage', 1)
  ).observes('uploader.isUploading')
