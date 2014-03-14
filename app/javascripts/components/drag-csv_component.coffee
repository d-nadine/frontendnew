require 'components/csv_reader_mixin'
require 'components/draggable_mixin'

Radium.DragCsvComponent = Ember.Component.extend Radium.CsvReaderMixin,
  Radium.DraggableMixin,

  drop: (e) ->
    @$('.dropbox').removeClass('hover')
    files = e.dataTransfer.files
    return if Ember.isEmpty(files)

    @send 'parseFile', e.dataTransfer.files[0]

    false
