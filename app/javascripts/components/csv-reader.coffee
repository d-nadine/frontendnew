Radium.CsvReaderComponent = Ember.TextField.extend
  actions:
    importToLarge: (rowCount) ->
      @sendAction 'cancel', rowCount
      false

  classNames: ['csv-upload']
  type: 'file'
  attributeBindings: ['multiple']
  multiple: false
  value: 'Import'
  disableImport: false

  change: (e) ->
    return unless e.target.files.length

    target = @get('controller.targetObject')

    @set 'controller.importing', true
    @set 'controller.disabled', true

    file = e.target.files[0]
    extension = file.name.split('.').pop().toLowerCase()

    unless extension == 'csv'
      @set 'controller.importing', false
      @set 'controller.disabled', false
      target.send 'flashError', 'You can only import files with a csv extension!'
      return

    reader = new FileReader()

    reader.addEventListener "load",  (e) =>
      lines = CSV.parse(e.target.result)

      if lines.length > 1000
        @set 'controller.importing', false
        @set 'controller.disabled', false
        @send 'importToLarge', lines.length
        return

      @set 'controller.disabled', true

      @sendAction 'finished', file: file, data: lines

    csv = reader.readAsText(file)
