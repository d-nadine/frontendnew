Radium.CsvReaderMixin = Ember.Mixin.create
  actions:
    parseFile: (file) ->
      target = @get('controller.targetObject')

      @set 'controller.isUploading', true
      @set 'controller.disabled', true

      extension = file.name.split('.').pop().toLowerCase()

      unless extension == 'csv'
        @set 'controller.isUploading', false
        @set 'controller.disabled', false
        target.send 'flashError', 'You can only import files with a csv extension!'
        return

      reader = new FileReader()

      reader.addEventListener "load",  (e) =>
        lines = CSV.parse(e.target.result)

        @set 'controller.disabled', true

        @sendAction 'finished', file: file, data: lines

      csv = reader.readAsText(file)

  value: 'Import'
  disableImport: false
