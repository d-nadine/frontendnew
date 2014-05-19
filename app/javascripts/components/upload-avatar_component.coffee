Radium.UploadAvatarComponent = Ember.Component.extend Radium.UploadingMixin,
  store: Ember.computed ->
    this.container.lookup "store:main"

  fileUploader: Ember.TextField.extend
    classNames: ['avatar-upload']
    attributeBindings: ['accept']
    accept: 'image/*'
    type: 'file'
    attributeBindings: ['multiple']
    multiple: false

  isLargeAvatar: ( ->
    @get('avatarsize') == "large"
  ).property('avatarsize')

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

