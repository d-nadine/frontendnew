Radium.UploadAvatarComponent = Ember.Component.extend Radium.UploadingMixin,
  store: Ember.computed ->
    this.container.lookup "store:main"

  fileUploader: Ember.TextField.extend
    classNames: ['avatar-upload']
    attributeBindings: ['accept', 'multiple']
    accept: 'image/*'
    type: 'file'
    multiple: false

  isLargeAvatar: Ember.computed 'avatarsize', ->
    @get('avatarsize') == "large"

  change: (e) ->
    return unless e.target.files.length

    file = e.target.files[0]

    url = "#{@get('store._adapter.url')}/avatars"
    uploader = @get('uploader')
    model = @get('model')
    modelAttributes = type: model.humanize(), id: model.get('id')

    @set 'isUploading', true

    uploader.upload(file, modelAttributes, url).then((data) =>
      store = @get("controller.store")
      adapter = store.adapterForType(model.constructor)
      adapter.didFindRecord(store, model.constructor, data, model.get('id'))
      @set 'isUploading', false
      Ember.run.next =>
        @sendAction "finishedUpload"
    ).catch (error) =>
      @send 'flashError', 'an error has occurred and the avatar cannot be uploaded'
      @set 'isUploading', false

