require 'mixins/views/uploading_mixin'
require 'components/draggable_mixin'

Radium.DragFileuploaderComponent = Ember.Component.extend Radium.UploadingMixin,
  Radium.DraggableMixin,

  init: ->
    @_super.apply this, arguments
    # FIXME: Total hack, remove when the initializer works
    @set 'controller.store', Radium.__container__.lookup('store:main')

  drop: (e) ->
    @$('.dropbox').removeClass('hover')
    files = e.dataTransfer.files
    return if Ember.isEmpty(files)

    @uploadFiles files

    false
