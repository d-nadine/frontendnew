Radium.LeadsImportController= Ember.ObjectController.extend
  actions:
    initialFileUploaded: (imported) ->
      unless imported.data.length
        @send 'flashError', 'The file contained no data'
        return

      map = (item) -> Ember.Object.create name: item

      headerData = imported.data[0].map map

      start = if @get('firstRowIsHeader') then 1 else 0

      firstDataRow = imported.data[start].map map

      @setProperties
        showInstructions: false
        initialImported: true
        importFile: imported.file
        headerData: headerData
        firstDataRow: firstDataRow

    importFile: (event) ->
      @set "importing", true
      return

    toggleInstructions: ->
      @toggleProperty "showInstructions"
      return

    cancelImport: (rowCount) ->
      @set 'rowCount', rowCount
      @set 'showLargeImportMessage', true
      @set 'showInstructions', false
      false

    dismissLargeImportMessage: ->
      @set 'rowCount', 0
      @set 'showLargeImportMessage', false
      @set 'showInstructions', false
      false

    reset: ->
      @setProperties
        importing: false
        percentage: 0
        showInstructions: false
        showLargeImportMessage: false
        initialImported: false
        rowCount: 0
        disableImport: false
        importFile: null
        firstRowIsHeader: true
        headerInfo: Ember.Object.create()

      @get('headerData').clear()
      @set('headerData', Ember.A())
      @get('firstDataRow').clear()
      @set('firstDataRow', Ember.A())

  importing: false
  percentage: 0
  showInstructions: false
  showLargeImportMessage: false
  initialImported: false
  rowCount: 0
  disableImport: false
  headerData: Ember.A()
  importFile: null
  firstRowIsHeader: true
  headerInfo: Ember.Object.create()
  firstDataRow: Ember.A()

  fileUploaded: (->
    if @get('importing')
      progresser = setInterval(=>
        if @get("percentage") < 100
          @incrementProperty "percentage"
        else
          clearInterval(progresser)
          @setProperties(
            importing: false
            percentage: 0
          )
      , 10)
  ).observes('importing').on('init')
