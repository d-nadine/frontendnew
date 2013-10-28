require 'mixins/views/uploading_mixin'

Radium.DragFileuploaderComponent = Ember.Component.extend Radium.UploadingMixin,
  init: ->
    @_super.apply this, arguments
    # FIXME: Total hack, remove when the initializer works
    @set 'controller.store', Radium.__container__.lookup('store:main')

  dragOver: (e) ->
    @$('.dropbox').addClass('hover')
    false

  dragEnd: (e) ->
    @$('.dropbox').removeClass('hover')
    false

  dragLeave: (e) ->
    @$('.dropbox').removeClass('hover')
    false

  drop: (e) ->
    @$('.dropbox').removeClass('hover')
    files = e.dataTransfer.files
    return if Ember.isEmpty(files)

    @uploadFiles files

    false
