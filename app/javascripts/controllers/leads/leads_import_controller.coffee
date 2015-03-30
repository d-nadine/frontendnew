require 'mixins/user_combobox_props'
rejectEmpty = (headerInfo, key) ->
        info = headerInfo.get(key)
        if Ember.isArray(info)
          input = info.reject (i) -> Ember.isEmpty(i.get('value'))
          !input.length
        else
          Ember.isEmpty(info)

Radium.LeadsImportController = Radium.ObjectController.extend Radium.PollerMixin,
  Radium.UserComboboxProps,
  actions:
    importContacts: ->
      selectedHeaders = @get('selectedHeaders')

      unless selectedHeaders.length
        @send 'flashError', 'You need to map the name or email field to the csv file.'
        return

      headerInfo = @get('headerInfo')

      @set('isSubmitted', true)

      if (!headerInfo.firstName && !headerInfo.lastName) && !headerInfo.name && !headerInfo.emailAddresses.length
        return @send 'flashError', 'You need to map the name or email field to the csv file.'

      unless assignedTo = @get('assignedTo')
        return @send 'flashError', 'You must select a user to assign the contacts to.'


      selectedHeaders = @get('selectedHeaders').slice()

      data = @getImportData(false, selectedHeaders).map (item) ->
                                    item.fields.map (item) -> item

      unless data.length
        @send 'flashError', "There are no valid rows in the imported file."
        return

      postHeaders = selectedHeaders.mapProperty('name')

      importJob = Radium.ContactImportJob.createRecord
                    headers: postHeaders
                    contactStatus: @get('contactStatus')
                    fileName: @get('importFile').name
                    public: true
                    assignedTo: assignedTo
                    tagNames: @get('tagNames').mapProperty('name')
                    rows: data

      hasCollectionMarker = (label, item) ->
        new RegExp("^#{label} \\d+$", 'i').test(item)

      hasEmails = hasCollectionMarker.bind(null, "Email Address")
      hasPhoneNumbers = hasCollectionMarker.bind(null, "PHone Number")

      collectionMapping = (item) ->
        primary: item.get('isPrimary')
        name: item.get('name')

      if postHeaders.any(hasEmails)
        importJob.set('emailAddresses', headerInfo.get('emailAddresses').map(collectionMapping))

      if postHeaders.any(hasPhoneNumbers)
        importJob.set('phoneNumbers', headerInfo.get('phoneNumbers').map(collectionMapping))

      @set('importing', true)

      importJob.save(this).then( =>
        @send 'pollForJob', importJob
        @set 'isSubmitted', false
      ).catch (result) =>
        @send 'flashError', 'an error has occurred and the job could not be completed.'
        @set 'pollImportJob', importJob
        @set('importing', false)
        @set 'isSubmitted', false
        @send 'reset'

    pollForJob: (importJob) ->
      @send 'reset'
      @set 'pollImportJob', importJob
      @set('importing', true)
      @start()

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
      @set 'showInstructions', false
      false

    dismissLargeImportMessage: ->
      @set 'rowCount', 0
      @set 'showInstructions', false
      false

    reset: ->
      @setProperties
        importing: false
        isSubmitted: false
        percentage: 0
        showInstructions: false
        initialImported: false
        isUploading: false
        rowCount: 0
        disableImport: false
        firstRowIsHeader: true
        contactStatus: null
        pollImportJob: null
        headerInfo: @getNewHeaderInfo()
        assignedTo: @get('currentUser')

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

  needs: ['tags', 'contactStatuses', 'users']

  user: Ember.computed.oneWay 'controllers.users'

  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'

  importing: false
  percentage: 3
  interval: 1000
  showInstructions: false
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
  contactStatus: null
  pollImportJob: null
  headerInfo: null
  firstDataRow: Ember.A()
  isNew: true
  isSubmitted: true

  sortedJobs: Ember.computed.sort 'model', (a, b) ->
    left = b.get('createdAt') || Ember.DateTime.create()
    right = a.get('createdAt') || Ember.DateTime.create()
    Ember.DateTime.compare left, right

  init: ->
    @_super.apply this, arguments
    self = this
    @addObserver 'sortedJobs.[]', this, 'jobsLoaded'

    @set 'headerInfo', @getNewHeaderInfo()

    @set 'assignedTo', @get('currentUser')
    Radium.computed.addAllKeysProperty this, 'selectedHeaders', 'headerInfo', 'firstRowIsHeader', 'headerInfo.emailAddresses.@each.value.name', 'headerInfo.phoneNumbers.@each.value.name', ->
      headerInfo = @get('headerInfo')

      headers = Ember.keys(headerInfo).reject rejectEmpty.bind(this, headerInfo)

      return Ember.A() unless headers.length

      self = this

      result = Ember.A()

      headers.forEach (header) ->
        headerInfoProp = self.get("headerInfo.#{header}")

        unless Ember.isArray(headerInfoProp)
          hash = Ember.Object.create
            name: header.replace(/([A-Z])/g, ' $1').replace(/^./, (str) -> str.toUpperCase())
            marker: headerInfoProp.get('name')

          return result.push(hash)

        counter = 0
        singlular = header.singularize()

        headerInfoProp.forEach (prop) ->
          hash = Ember.Object.create
                   name: "#{singlular} #{counter + 1}"
                   marker: headerInfoProp.objectAt(counter).get('value.name')

          result.push(hash)
          counter++

      result

  jobsLoaded: ->
    removeObserver = =>
      @removeObserver 'sortedJobs.[]', this, 'jobsLoaded'

    if @get('importing')
      removeObserver()
      return

    unless firstJob = @get('sortedJobs.firstObject')
      removeObserver()
      return

    unless firstJob.get('isProcessing')
      removeObserver()
      return

    removeObserver()

    @send 'pollForJob', firstJob

  previewData: Ember.computed 'selectedHeaders.[]', ->
    selectedHeaders = @get('selectedHeaders').slice()
    @getImportData(true, selectedHeaders)

  getImportData: (isPreview, selectedHeaders) ->
    selectedHeaders = selectedHeaders.mapProperty('marker')

    return unless selectedHeaders.length

    headerData = @get('headerData').mapProperty('name')

    data = @get('importedData')

    if isPreview && data.length > 6
      data = data.slice(0, 6)

    if @get('firstRowIsHeader')
      data = data.slice(1)

    data.map (row) ->
      Ember.Object.create
        fields: selectedHeaders.map (header) ->
          index = headerData.indexOf(header)
          row[index]

  getNewHeaderInfo: ->
    Ember.Object.create
      firstName: null
      lastName: null
      name: null
      companyName: null
      emailAddresses: Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
      phoneNumbers: Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
      title: null
      website: null
      street: null
      city: null
      state: null
      zip: null
      country: null
      about: null
      fax: null
      lists: null
      notes: null
      gender: null

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
