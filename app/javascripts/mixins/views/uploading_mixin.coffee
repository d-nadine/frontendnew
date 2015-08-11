require 'lib/radium/ember-uploader'

Radium.UploadingMixin = Ember.Mixin.create
  percentage: 0

  uploadFiles: (files) ->
    @get('uploader').on('progress', this, 'onDidProgress')
    @set('disableSave', true)
    uploader = @get('uploader')
    uploadToFiles = @get('files')

    Ember.assert "You have not set the files array for UploadingMixin in #{@constructor.toString()}", uploadToFiles

    for i in [0...files.length]
      file = files[i]
      wrappedFile = Ember.Object.create(file, file: file, isUploading: true)

      uploadToFiles.pushObject(wrappedFile)

      model = @get('model')

      hash = if model?.humanize
                type: model.humanize(), id: model.get('id')
              else
                bucket: @get('bucket')

      uploader.upload(file, hash)
        .then(@handlerFactory(wrappedFile).bind(this))
        .catch (error) =>
          Ember.Logger.error error
          controller = if this instanceof Ember.Component
                         @get('targetObject')
                       else
                          this

          route = controller.container.lookup('route:application')

          route.send 'flashError', "an error has occurred and the file could not be uploaded."

    false

  handlerFactory: (wrappedFile) ->
    (data) =>
      id = data["attachment"]["id"]
      store = @get("controller.store")
      adapter = store.adapterForType(Radium.Attachment)
      adapter.didFindRecord(store, Radium.Attachment, data, id)
      attachment = Radium.Attachment.find(id)
      attachment.get('reference').reload() if attachment.get('reference')
      wrappedFile.set 'isUploading', false
      wrappedFile.set 'attachment', attachment

      isUploading = @get('files').any (file) -> file.get('isUploading')
      @set('disableSave', isUploading)

  onDidProgress: (percent) ->
    return if @isDestroyed || @isDestroying
    @set('percentage', percent)

  isUploadingDidChange: Ember.observer 'uploader.isUploading', ->
    return if @isDestroyed || @isDestroying
    @set('percentage', 1)
