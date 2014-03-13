Radium.LeadsImportController= Ember.ObjectController.extend
  actions:
    importContacts: ->
      selectedHeaders = @get('selectedHeaders')

      unless selectedHeaders.length
        @send 'flashError', 'You need to map the name or email field to the csv file.'
        return

      headerInfo = @get('headerInfo')

      if (!headerInfo.firstName && !headerInfo.lastName) && !headerInfo.name && !headerInfo.email
        @send 'flashError', 'You need to map the name or email field to the csv file.'
        return

      headers = Ember.keys(@get('headerInfo')).reject (key) -> Ember.isEmpty(headerInfo.get(key))

      data = @getImportData(false).map (item) ->
                                    item.fields.map (item) -> item

      importJob = Radium.ContactImportJob.createRecord
                    headers: headers
                    rows: data
                    status: @get('status')
                    fileName: @get('importFile').name

      @get('tagNames').forEach (tag) =>
        importJob.get('tagNames').push tag.get('name')

      importJob.one 'didCreate', =>
        @set 'isSaving', false
        @send 'reset'

      @get('store').commit()

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
        importedData: imported.data

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
        status: 'pipeline'
        headerInfo: Ember.Object.create
          firstName: null
          lastName: null
          name: null
          companyName: null
          email: null
          phone: null
          street: null
          city: null
          state: null
          zip: null
          country: null

      @get('headerData').clear()
      @set('headerData', Ember.A())
      @get('firstDataRow').clear()
      @set('firstDataRow', Ember.A())
      @get('importedData').clear()
      @set('importedData', Ember.A())
      @get('tagNames').clear()
      @set('tagNames', Ember.A())

    addTag: (tag) ->
      return if @get('tagNames').mapProperty('name').contains tag

      @get('tagNames').addObject Ember.Object.create name: tag

  needs: ['tags']

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
  importedData: Ember.A()
  tagNames: Ember.A()
  isEditable: true
  status: 'pipeline'

  headerInfo: Ember.Object.create
    firstName: null
    lastName: null
    name: null
    companyName: null
    email: null
    phone: null
    street: null
    city: null
    state: null
    zip: null
    country: null

  firstDataRow: Ember.A()

  init: ->
    @_super.apply this, arguments
    self = this
    Radium.computed.addAllKeysProperty this, 'selectedHeaders', 'headerInfo', ->
      headerInfo = @get('headerInfo')

      headers = Ember.keys(headerInfo).reject (key) -> Ember.isEmpty(headerInfo.get(key))

      return Ember.A() unless headers.length

      headers.map (header) ->
        hash =
          name: header.replace(/([A-Z])/g, ' $1')
                 .replace(/^./, (str) -> str.toUpperCase()),
          marker: self.get("headerInfo.#{header}.name")

        Ember.Object.create(hash)

  previewData: Ember.computed 'selectedHeaders.[]', ->
    @getImportData(true)

  getImportData: (isPreview) ->
    selectedHeaders = @get('selectedHeaders').mapProperty('marker')

    return unless selectedHeaders.length

    headerData = @get('headerData').mapProperty('name')

    data = @get('importedData')

    if isPreview && data.length > 20
      data = data.slice(0, 20)

    if @get('firstRowIsHeader')
      data = data.slice(1)

    data.map (row) =>
      Ember.Object.create
        fields: selectedHeaders.map (header) =>
          index = headerData.indexOf(header)
          row[index]

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
