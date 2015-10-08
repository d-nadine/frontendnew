require 'mixins/user_combobox_props'
require "mixins/common_modals"

rejectEmpty = (headerInfo, key) ->
        info = headerInfo.get(key)
        if Ember.isArray(info)
          input = info.reject (i) -> Ember.isEmpty(i.get('value'))
          !input.length
        else
          Ember.isEmpty(info)

Radium.LeadsImportController = Radium.Controller.extend  Radium.PollerMixin,
  Radium.UserComboboxProps,
  actions:
    addList: (list) ->
      return if @get('lists').contains list

      unless list.constructor is Radium.List
        Ember.assert "You must include the Radium.CommonModals mixin to create a new list", @_actions['createList']

        return @send 'createList', list, model

      @get('lists').addObject list

      false

    removeList: (list) ->
      return unless @get('lists').contains list

      @get('lists').removeObject list

      false

    confirmDeleteJob: (job) ->
      @set "deleteJob", job

      @set "showDeleteConfirmation", true

      false

    importContacts: ->
      selectedHeaders = @get('selectedHeaders')

      unless selectedHeaders.length
        @send 'flashError', 'You need to map the name or email field to the csv file.'
        return

      headerInfo = @get('headerInfo')

      @set('progressIndicator', 0)
      @set('isSubmitted', true)

      if (!headerInfo.firstName && !headerInfo.lastName) && !headerInfo.name && !headerInfo.emailMarkers.length
        return @send 'flashError', 'You need to map the name or email field to the csv file.'

      unless assignedTo = @get('assignedTo')
        return @send 'flashError', 'You must select a user to assign the contacts to.'


      data = @getImportData(true, selectedHeaders).map (item) ->
                                    item.fields.map (item) -> item

      unless data.length
        @send 'flashError', "There are no valid rows in the imported file."
        return

      @progress()

      importJob = Radium.ContactImportJob.createRecord
                    headerMappings: selectedHeaders
                    contactStatus: @get('contactStatus')
                    public: true
                    assignedTo: assignedTo
                    lists: @get('lists').mapProperty('id')

      hasCollectionMarker = (label, item) ->
        new RegExp("^#{label} \\d+$", 'i').test(item.name)

      hasEmails = hasCollectionMarker.bind(null, "Email Address")
      hasPhoneNumbers = hasCollectionMarker.bind(null, "Phone Number")

      collectionMapping = (item, index) ->
        index: index
        primary: item.get('isPrimary')
        name: item.get('name').toLowerCase()

      if selectedHeaders.any(hasEmails)
        importJob.set('emailMarkers', headerInfo.get('emailMarkers').map(collectionMapping))

      if selectedHeaders.any(hasPhoneNumbers)
        importJob.set('phoneNumberMarkers', headerInfo.get('phoneNumberMarkers').map(collectionMapping))

      headerData = @get('headerData').mapProperty('name')

      mappings = @get('customFieldMappings').reject((f) -> !f.get('mapping')).map (f) ->
        index: f.get('index')
        custom_field_id: f.get('field.id')

      importJob.set 'customFieldMappings', mappings

      @set('importing', true)

      uploader = @get('uploader')

      Ember.assert "you must have a bucket to upload", @get('bucket')

      hash = bucket: @get('bucket')

      importFile = @get('importFile')

      uploader.upload(importFile, hash).then((result) =>
        attachment = DS.Model.instanceFromHash(result, "attachment", Radium.Attachment, @get('store'))

        importJob.set 'file', attachment

        importJob.save().then( =>
          Radium.ContactImportJob.find({}).then (results) =>
            @set 'contactImportJobs', results

          @pollForJob(importJob)
        )
      ).catch((error) =>
        @send 'flashError', 'an error has occurred and the job could not be completed.'
        @set 'pollImportJob', importJob
        @set('importing', false)
        @send 'reset'
        throw error
      ).finally =>
        @set 'isSubmitted', false

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
      @get('lists').clear()
      @set('lists', Ember.A())

      @get('customFieldMappings').forEach (f) ->
        f.set('mapping', null)
        f.set('index', null)

      @set('bucket', Math.random().toString(36).substr(2,9))
    initialFileUploaded: (imported) ->
      @set 'isUploading', false
      unless imported.data.length
        @send 'flashError', 'The file contained no data'
        return

      map = (item) -> Ember.Object.create name: item

      unless headerData = imported.data[0].map map
        return @send "flashError", "the file contains no valid data"

      unless firstDataRow = imported.data[1].map map
        return @send "flashError", "the file contains no valid data"

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

  needs: ['contactStatuses', 'users']

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
  lists: Ember.A()
  contactStatus: null
  pollImportJob: null
  headerInfo: null
  firstDataRow: Ember.A()
  isNew: true
  isSubmitted: true
  customFieldMappings: Ember.A()
  contactImportJobs: Ember.A()
  bucket: Math.random().toString(36).substr(2,9)

  sortedJobs: Ember.computed.sort 'contactImportJobs', (a, b) ->
    left = b.get('createdAt') || Ember.DateTime.create()
    right = a.get('createdAt') || Ember.DateTime.create()
    Ember.DateTime.compare left, right

  init: ->
    @_super.apply this, arguments
    self = this

    @set 'headerInfo', @getNewHeaderInfo()

    @set 'assignedTo', @get('currentUser')
    Radium.computed.addAllKeysProperty this, 'selectedHeaders', 'headerInfo', 'firstRowIsHeader', 'headerInfo.emailMarkers.@each.value.name', 'headerInfo.phoneNumberMarkers.@each.value.name', 'customFieldMappings.@each.mapping', ->
      headerInfo = @get('headerInfo')

      headers = Ember.keys(headerInfo).reject rejectEmpty.bind(this, headerInfo)

      self = this

      result = Ember.A()

      headers.forEach (header) ->
        headerInfoProp = self.get("headerInfo.#{header}")

        unless Ember.isArray(headerInfoProp)
          fileColumn = headerInfoProp.get('name')
          index = headerInfoProp.get('index')

          Ember.assert "A valid index has been selected for prop", index > - 1

          hash =
            name: header.replace(/([A-Z])/g, ' $1').replace(/^./, (str) -> str.toUpperCase())
            marker: fileColumn
            index: index

          return result.push(hash)

        counter = 0
        singlular = header.singularize()

        headerInfoProp.forEach (prop) ->
          fileColumn = headerInfoProp.objectAt(counter).get('value.name')
          index = prop.get('value.index')

          Ember.assert "A valid index has been selected for prop", index > - 1

          hash =
            name: "#{singlular} #{counter + 1}"
            marker: fileColumn
            index: index

          result.push(hash)
          counter++

      @get('customFieldMappings').forEach (f) ->
        fieldName = f.get('field.name')

        if f.get('mapping')
          headers.push fieldName
          fileColumn = f.get('mapping.name')
          index = f.get('mapping.index')

          Ember.assert "A valid index has been selected for customField headerInfoProp", index > - 1

          hash =
            name: fieldName
            marker: fileColumn
            index: index

          f.set('index', index)

          result.push(hash)
        else
          index = headers.indexOf(fieldName)
          headers.removeAt(index) unless index == -1

      return Ember.A() unless headers.length

      result

  previewData: Ember.computed 'selectedHeaders.[]', ->
    selectedHeaders = @get('selectedHeaders').slice()
    @getImportData(true, selectedHeaders)

  getImportData: (isPreview, selectedHeaders) ->
    return unless selectedHeaders.length

    headerData = @get('headerData').mapProperty('name')

    data = @get('importedData')

    if isPreview && data.length > 6
      data = data.slice(0, 6)

    if @get('firstRowIsHeader')
      data = data.slice(1)

    data = data.map (row) ->
      Ember.Object.create
        fields: selectedHeaders.map (header) ->
          if mapping = header.mapping
            index = headerData.indexOf(mapping)
          else
            index = headerData.indexOf(header.marker)

          row[index]

    data

  getNewHeaderInfo: ->
    Ember.Object.create
      firstName: null
      lastName: null
      name: null
      companyName: null
      emailMarkers: Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
      phoneNumberMarkers: Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
      title: null
      website: null
      street: null
      line2: null
      city: null
      state: null
      zip: null
      country: null
      about: null
      fax: null
      lists: null
      notes: null
      gender: null

  pollForJob: (importJob) ->
    @send 'reset'
    @set 'pollImportJob', importJob
    @set('importing', true)
    @start()

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
        @get('container').lookup('route:leadsImport').refresh()
        return

      importedCount = job.get('importedCount')
      total = job.get('totalCount')
      percentage = Math.floor (importedCount / total) * 100

      @set('percentage', percentage)

    job.reload()

  progressIndicator: 0

  fakeProgressWidth: Ember.computed 'progressIndicator', ->
    "width: #{@get('progressIndicator')}%"

  _teardown: ->
    if progressTick = @get('progressTick')
      Ember.run.cancel progressTick

  deleteJob: null

  progress: ->
    unless @get('isSubmitted')
      @_teardown()
      return

    progressTick = Ember.run.later this, =>
      nextProgress = @get('progressIndicator') + 3

      if nextProgress >= 100
        nextProgress = 0

      Ember.run.next =>
        if @isDestroyed || @isDestroying
          @_teardown()
          return

        @set 'progressIndicator', nextProgress

      @progress()
    , 300

    @set "progressTick", progressTick

