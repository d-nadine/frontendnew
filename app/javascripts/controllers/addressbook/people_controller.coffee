require "controllers/addressbook/people_mixin"

Radium.PeopleIndexController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.ContactColumnsConfig,
  actions:
    addNewCustomQuery: (queryParts) ->
      customQuery =
        customQueryParts: queryParts

      unless currentCustomQuery = @get('currentCustomQuery')
        @get('newCustomQueries').addObject customQuery

      @set 'currentCustomQuery', customQuery

      false

    saveCustomQuery: (query) ->
      currentUser = @get('currentUser')

      customQuery = currentUser.get('customQueries').createRecord(name: query.name)

      query.customQueryParts.forEach (part) ->
        part.operatorType = part.operator_type
        delete part.operator_type
        customQuery.get('customQueryParts').createRecord part

      currentUser.save(this).then( (result) =>
        @send 'flashSuccess', "The dynamic list #{result.get('name')} has been created."

        customQuery = result.get('customQueries').find (q) -> q.get('name') == query.name

        Ember.assert "customQuery was not found", customQuery

        @send 'showCustomQueryContacts', customQuery
      ).finally =>
        @get('newCustomQueries').clear()

      false

    runCustomQuery: (queryParts) ->
      Ember.assert 'empty array sent to runCustomQuery', queryParts.length

      model = @get('model')
      params = model.get('params')

      delete params.custom_query

      custom_query = "custom_query": JSON.stringify(queryParts)

      params = Ember.merge custom_query, params

      model.set 'params', params

      false

    unTrackAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "untrack", detail
      false

    saveTag: (newTag) ->
      tagNames = @get('tags').mapProperty('name').map((name) -> name.toLowerCase()).toArray()

      if tagNames.contains(newTag.get('name').toLowerCase())
        @send 'flashError', 'A list with this name already exists.'
        return

      tag = Radium.Tag.createRecord(name: newTag.get('name'), account: @get('currentUser.account'))

      tag.save(this).then (tag) =>
        @get('newTags').removeObject newTag

        @send 'flashSuccess', "New list successfully created."

        Radium.Tag.find({})

        @send 'updateTotals'

      false

    createTag: ->
      @get('newTags').pushObject Ember.Object.create name: ''

      false

    saveCity: (context) ->
      unless context.get('model.city')
        city = context.get('bufferedProxy.city')
        context.get('bufferedProxy').discardBufferedChanges()

        context.get('model.addresses').createRecord
          name: 'work'
          isPrimary: true
          city: city

    saveCompanyName: (context) ->
      if Ember.isEmpty(context.get('bufferedProxy.companyName')) && context.get('model.company')
        context.set('bufferedProxy.removeCompany', true)
        context.set('bufferedProxy.company', null)

      model = context.get('model')

      model.one 'didReload', (result) =>
        unless company = model.get('company')
          return

        @get('controllers.addressbook').send 'updateTotals'
        company.reload()

    savePhone: (context) ->
      unless context.get('model.phone')
        phone = context.get('bufferedProxy.phone')
        context.get('bufferedProxy').discardBufferedChanges()

        context.get('model.phoneNumbers').createRecord
                         name: 'work'
                         value: phone
                         isPrimary: true

    addTag: (tag) ->
      detail =
        tag: tag
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact

      @send "executeActions", "tag", detail
      false

    assignAll: (user) ->
      detail =
        user: user
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact

      @send "executeActions", "assign", detail
      false

    setStatus: (status) ->
      detail =
        status: status
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact

      @send 'executeActions', "status", detail

    deleteAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: true
        private: false

      @send "executeActions", "delete", detail
      false

    updateTotals: ->
      Radium.ContactsTotals.find({}).then (results) =>
        totals = results.get('firstObject')
        @set 'all', totals.get('all')
        @set 'new', totals.get('new')
        @set 'noTasks', totals.get('noTasks')
        @set 'inactive', totals.get('inactive')
        @set 'noList', totals.get('noList')
        @set 'usersTotals', totals.get('usersTotals')
        @set 'tagsTotals', totals.get('tagsTotals')

    showUsersContacts: (user) ->
      @transitionToRoute 'people.index', 'assigned_to', queryParams: user: user.get('id')
      false

    showTagsContacts: (tag) ->
      @transitionToRoute 'people.index', 'tagged', queryParams: tag: tag.get('id')
      false

    showCustomQueryContacts: (query) ->
      @transitionToRoute 'people.index', 'dynamicquery', queryParams: customquery: query.get('uid')
      false

    deleteCustomQuery: (query) ->
      currentUser = @get('currentUser')
      currentUser.get('customQueries').removeObject query

      currentUser.save(this).then =>
        @send 'flashSuccess', "Custom Query deleted"

      @transitionToRoute 'people.index', 'all', queryParams: customquery: ''
      false

    deleteTag: (tag) ->
      tagName = tag.get('name')
      tagId = tag.get('id')

      return unless confirm("Are you sure you want to delete the #{tagName} list?")

      tag.delete(this).then =>
        @send 'flashSuccess', "The tag #{tagName} has been deleted."

        @transitionToRoute "people.index", "all" if @tag == tagId

      false

  localUntrack: (contact, dataset) ->
    contact.set 'isChecked', false
    Ember.run.next =>
      @get('model').removeObject contact

  needs: ['addressbook', 'users', 'tags', 'contactStatuses', 'company', 'untrackedIndex']

  noContacts: Ember.computed.oneWay 'controllers.addressbook.noContacts'

  users: Ember.computed.oneWay 'controllers.users'
  tags: Ember.computed.oneWay 'controllers.tags'
  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'
  contactsTotal: Ember.computed.oneWay 'controllers.addressbook.contactsTotal'

  queryParams: ['user', 'tag', 'company', 'contactimportjob', 'customquery']
  user: null
  company: null
  contactimportjob: null
  customquery: null

  filter: null

  isAll: Ember.computed.equal 'filter', 'all'
  isNew: Ember.computed.equal 'filter', 'new'
  isNoTasks: Ember.computed.equal 'filter', 'notasks'
  isLosing: Ember.computed.equal 'filter', 'losing'
  isNoList: Ember.computed.equal 'filter', 'no_list'
  isTagged: Ember.computed.equal 'filter', 'tagged'
  isAssignedTo: Ember.computed.equal 'filter', 'assigned_to'
  isQuery: Ember.computed.equal 'filter', 'dynamicquery'

  newTags: Ember.A()

  public: true
  private: false

  isCurrentUser: Ember.computed 'currentUser', 'isAssignedTo', 'user', ->
    return unless @get('isAssignedTo') && @get('user')

    @get('currentUser.id') == @get('user')

  currentDisplay: Ember.computed 'currentUser', ->
    "@#{@get('currentUser.displayName')}"

  currentContactsTotal: Ember.computed 'currentUser', 'usersTotals', ->
    unless usersTotals = @get('usersTotals')
      return

    unless userId = @get('currentUser.id')
      return

    r = usersTotals.find((user) -> user.id == parseInt(userId))

    r.total || 0

  team: Ember.computed 'currentUser', 'users.[]', ->
    currentUser = @get('currentUser')

    @get('users').reject (user) -> user == currentUser

  filterParams: Ember.computed 'filter', 'user', 'tag', 'company', 'contactimportjob', ->
    params =
      public: true
      private: false
      filter: @get('filter')
      page_size: @get('pageSize')

    if company = @get('company')
      params = Ember.merge params, company: @get('company')

    if contactimportjob = @get('contactimportjob')
      params = Ember.merge params, contact_import_job: @get('contactimportjob')

    if user = @get('user') && @get('isAssignedTo')
      return Ember.merge params, user: @get('user')

    if tag = @get('tag') && @get('isTagged')
      return Ember.merge params, tag: @get('tag')

    if @get('isQuery')
      Ember.assert "You must have a query query for a custom query queryParam", customquery = @get('customquery')
      return Ember.merge params, customquery: customquery

    params

  noResults: Ember.computed 'content.isLoading', 'model.[]', ->
    not @get('content.isLoading') && not @get('model').get('length')

  pageSize: 25

  combinedColumns: Ember.computed 'columns.[]', 'customFields.[]', ->
    columns = @get('columns')
    customFields = @get('customFields') || []

    customFieldsConfig = customFields.map (field) ->
      identifier = "#{field.get('name')}-#{field.get('type')}-#{field.get('id')}"

      col =
        id: identifier
        classNames: "custom-field"
        isCustomField: true
        heading: field.get('name')
        bindings: [
          {name: "fieldId", value: field.get('id'), static: true}
          {name: "resource", value: "model"}
          {name: "parent", value: "parentController.targetObject"}
          {name: "customFields", value: "parentController.targetObject.customFields"}
          {name: "isEditing", value: true, static: true}
          {name: "tableCell", value: true, static: true}
        ]
        component: "customfield-editor"

      col

    combined = columns.concat customFieldsConfig

    savedColumns = JSON.parse(localStorage.getItem(@SAVED_COLUMNS))

    cols = combined.filter((c) -> savedColumns.contains(c.id))

    unless cols.length
      cols = combined.filter((c) => @initialColumns.contains(c.id))

    cols.setEach 'checked', true

    combined

  checkedColumns: Ember.computed.filterBy 'combinedColumns', 'checked'

  checkedColumnsDidChange: Ember.observer 'checkedColumns.length', ->
    checked = @get('checkedColumns').filter((c) -> c.checked).mapProperty 'id'

    return unless checked.length

    localStorage.setItem @SAVED_COLUMNS, JSON.stringify(checked)

  queries: Ember.A()
  newCustomQueries: Ember.A()

  queryFields: [
    {
      key: "name"
      displayName: "Name"
      operator: "text"
    }
    {
      key: "email"
      displayName: "Email"
      operator: "text"
    }
    {
      key: "company"
      displayName: "Company"
      operator: "text"
    }
    {
      key: "city"
      displayName: "City"
      operator: "text"
    }
    {
      key: "last_activity"
      displayName: "Last Activity"
      operator: "number"
    }
  ]
