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
      for file in files
        uploader.upload(file)

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
