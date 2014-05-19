require 'mixins/views/uploading_mixin'
require 'components/draggable_mixin'

Radium.DragFileuploaderComponent = Ember.Component.extend Radium.UploadingMixin,
  Radium.DraggableMixin,

  store: Ember.computed ->
    this.container.lookup "store:main"

  drop: (e) ->
    @$('.dropbox').removeClass('hover')
    files = e.dataTransfer.files
    return if Ember.isEmpty(files)

    @uploadFiles files

    false
