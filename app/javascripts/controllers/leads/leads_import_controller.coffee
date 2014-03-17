Radium.LeadsImportController= Ember.ObjectController.extend Radium.PollerMixin,
  actions:
    addNewAdditionalField: ->
      @get('additionalFields').addObject @getNewAdditionalField()

    removeAdditionalField: (field) ->
      @get('additionalFields').removeObject field

      return if @get('additionalFields.length')

      @send 'addNewAdditionalField'

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

      importJob = Radium.ContactImportJob.createRecord
                    headers: headers
                    status: @get('status')
                    fileName: @get('importFile').name

      additionalFields = Ember.A()

      @get('additionalFields').forEach (field) =>
        return unless field.get('mapping')

        mapping = field.get('mapping.name')

        return if additionalFields.mapProperty('mapping').contains mapping

        unless importJob.get('headers').contains(mapping)
          importJob.get("headers").pushObject mapping
          @get('selectedHeaders').push Ember.Object.create marker: mapping, name: mapping

        additionalFields.push type: field.get('type'), mapping: mapping

      additionalFields = additionalFields.compact()

      importJob.set('additionalFields', additionalFields) if additionalFields.length

      data = @getImportData(false).map (item) ->
                                    item.fields.map (item) -> item

      importJob.set 'rows', data

      @get('tagNames').forEach (tag) =>
        importJob.get('tagNames').push tag.get('name')

      importJob.one 'didCreate', =>
        @send 'reset'
        @set 'pollImportJob', importJob
        @set('importing', true)
        @start()

      @get('store').commit()

    initialFileUploaded: (imported) ->
      @set 'isUploading', false
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
        initialImported: true

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
        isUploading: false
        rowCount: 0
        disableImport: false
        firstRowIsHeader: true
        status: 'pipeline'
        pollImportJob: null
        headerInfo: @getNewHeaderInfo()

      @get('headerData').clear()
      @set('headerData', Ember.A())
      @get('firstDataRow').clear()
      @set('firstDataRow', Ember.A())
      @get('importedData').clear()
      @set('importedData', Ember.A())
      @get('tagNames').clear()
      @set('tagNames', Ember.A())
      @get('additionalFields').clear()
      @set('additionalFields', Ember.A([@getNewAdditionalField()]))

    addTag: (tag) ->
      return if @get('tagNames').mapProperty('name').contains tag

      @get('tagNames').addObject Ember.Object.create name: tag

  needs: ['tags']

  importing: false
  percentage: 3
  interval: 1000
  showInstructions: false
  showLargeImportMessage: false
  initialImported: false
  isUploading: false
  rowCount: 0
  disableImport: false
  headerData: Ember.A()
  importFile: null
  firstRowIsHeader: true
  importedData: Ember.A()
  tagNames: Ember.A()
  isEditable: true
  status: 'pipeline'
  pollImportJob: null
  additionalFields: Ember.A()
  headerInfo: null

  firstDataRow: Ember.A()

  sortedJobs: Ember.computed.sort 'model', (a, b) ->
    left = b.get('createdAt') || Ember.DateTime.create()
    right = a.get('createdAt') || Ember.DateTime.create()
    Ember.DateTime.compare left, right

  init: ->
    @_super.apply this, arguments
    self = this

    @set 'additionalFields', Ember.A([@getNewAdditionalField()])
    @set 'headerInfo', @getNewHeaderInfo()
    Radium.computed.addAllKeysProperty this, 'selectedHeaders', 'headerInfo', 'firstRowIsHeader', ->
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

    if isPreview && data.length > 6
      data = data.slice(0, 6)

    if @get('firstRowIsHeader')
      data = data.slice(1)

    data.map (row) =>
      Ember.Object.create
        fields: selectedHeaders.map (header) =>
          index = headerData.indexOf(header)
          row[index]

  getNewAdditionalField: ->
    Ember.Object.create type: 'contact', mapping: null

  getNewHeaderInfo: ->
    Ember.Object.create
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

  onPoll: ->
    unless job = @get('pollImportJob')
      @stop()
      return

    job.one 'didReload', =>
      if job.get('finished')
        @set('percentage', 100)
        @set('importing', false)
        @stop()
        @send 'flashSuccess', 'The contacts have been successfully imported.'
        @send 'reset'
        @set 'importFile', null
        Radium.Contact.find({})
        return

      importedCount = job.get('importedCount')
      total = job.get('totalCount')
      percentage = Math.floor (importedCount / total) * 100

      @set('percentage', percentage)

    job.reload()
