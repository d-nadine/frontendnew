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
        importFile: imported.file
        headerData: headerData
        firstDataRow: firstDataRow

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
        headerInfo: Ember.Object.create
          firstName: null
          lastName: null
          name: null

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
  headerInfo: Ember.Object.create
    firstName: null
    lastName: null
    name: null
  firstDataRow: Ember.A()

  init: ->
    @_super.apply this, arguments
    Radium.computed.addAllKeysProperty this, 'previewHeaders', 'headerInfo', ->
      headerInfo = @get('headerInfo')

      headers = Ember.keys(headerInfo).reject (key) -> Ember.isEmpty(headerInfo.get(key))

      return Ember.A() unless headers.length

      headers.map (header) -> 
        header = header .replace(/([A-Z])/g, ' $1')
                        .replace(/^./, (str) -> str.toUpperCase())

        Ember.Object.create(header: header)

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
            initialImported: true
          )
      , 10)
  ).observes('importing').on('init')
