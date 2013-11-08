require 'mixins/views/uploading_mixin'

Radium.FileUploaderComponent = Ember.TextField.extend Radium.UploadingMixin,
  classNames: ['upload-button']
  type: 'file'
  attributeBindings: ['multiple']

  init: ->
    @_super.apply this, arguments
    # FIXME: Total hack, remove when the initializer works
    @set 'controller.store', Radium.__container__.lookup('store:main')

  change: (e) ->
    files = e.target.files
    return if Ember.isEmpty(files)

    @uploadFiles files
