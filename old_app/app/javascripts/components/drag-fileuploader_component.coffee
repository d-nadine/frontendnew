require 'mixins/views/uploading_mixin'
require 'components/draggable_mixin'

Radium.DragFileuploaderComponent = Ember.Component.extend Radium.UploadingMixin,
  Radium.DraggableMixin,

  drop: (e) ->
    @$('.dropbox').removeClass('hover')
    files = e.dataTransfer.files
    return if Ember.isEmpty(files)

    @uploadFiles files

    false
