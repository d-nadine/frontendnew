Radium.UploadAvatarComponent = Ember.Component.extend Radium.UploadingMixin,
  init: ->
    @_super.apply this, arguments
    # FIXME: Total hack, remove when the initializer works
    @set 'controller.store', Radium.__container__.lookup('store:main')

  fileUploader: Ember.TextField.extend
    classNames: ['avatar-upload']
    attributeBindings: ['accept']
    accept: 'image/*'
    type: 'file'

  change: (e) ->
    return unless e.target.files.length

    file = e.target.files[0]

    url = "#{@get('controller.store._adapter.url')}/avatars"
    uploader = @setUploader(url)
    model = @get('parentView.controller.model')
    modelAttributes = type: model.humanize(), id: model.get('id')

    @set 'isUploading', true

    uploader.upload(file, modelAttributes).then((data) =>
      store = @get("controller.store")
      adapter = store.adapterForType(model.constructor)
      adapter.didFindRecord(store, model.constructor, data, model.get('id'))
      @sendAction 'finishedUpload'
      @set 'isUploading', false
    , (data) =>
      @send 'flashError', 'an error has occurred and the avatar cannot be uploaded'
      @set 'isUploading', false
    )

