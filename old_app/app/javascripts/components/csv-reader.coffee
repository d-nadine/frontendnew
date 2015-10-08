require 'components/csv_reader_mixin'

Radium.CsvReaderComponent = Ember.TextField.extend Radium.CsvReaderMixin,
  classNames: ['csv-upload']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: false

  change: (e) ->
    return unless e.target.files.length

    @send 'parseFile', e.target.files[0]
