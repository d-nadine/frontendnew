require "controllers/addressbook/people_mixin"
require "mixins/save_contact_actions"

Radium.PeopleIndexController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.ContactColumnsConfig,
  Radium.SaveContactActions,
  actions:
    showContactModal: (contact) ->
      @set 'modalContact', contact

      Ember.run.next =>
        @set 'showContactModal', true

      false

    closeContactModal: ->
      @set 'showContactModal', false

      Ember.run.next =>
        @set 'showContactModal', null

      false

    toggleFilter: ->
      element = $('.query-builder-component')

      componentIsVisible = $('.query-builder-component').is(':visible')

      unless @get('isQuery')
        @set 'potentialQueries', Ember.A()
        @set 'actualQueries', Ember.A()

      if componentIsVisible
        element.fadeOut()
      else
        element.fadeIn()

      false

    persistCustomQuery: (queryParts) ->
      customQuery =
        customQueryParts: queryParts

      if @get('isQuery')
        @send "saveCustomQuery", customQuery
      else
        @get('newCustomQueries').addObject customQuery

      @set 'currentCustomQuery', customQuery

      false

    saveCustomQuery: (query) ->
      currentUser = @get('currentUser')

      if @get('isQuery')
        customQuery = currentUser.get('customQueries').find (q) => q.get('uid') == @get('customquery')

        customQuery.get('customQueryParts').clear()
      else
        customQuery = currentUser.get('customQueries').createRecord(name: query.name)

      query.customQueryParts.forEach (part) ->
        part.operatorType = part.operatorType
        customQuery.get('customQueryParts').createRecord part

      currentUser.save().then( (result) =>
        @send 'flashSuccess', "The dynamic list #{result.get('name')} has been created."

        customQuery = result.get('customQueries').find (q) -> q.get('name') == customQuery.get('name')

        Ember.assert "customQuery was not found", customQuery

        @send 'showCustomQueryContacts', customQuery
      ).finally =>
        @get('newCustomQueries').clear()

      false

    runCustomQuery: (queryParts, refresh) ->
      unless queryParts.length
        return unless refresh
        @send "toggleFilter"
        return Ember.run.next =>
          @get("container").lookup('route:peopleIndex').refresh()

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

      tag.save().then (tag) =>
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
        @set 'potential', totals.get('potential')
        @set 'new', totals.get('new')
        @set 'noTasks', totals.get('noTasks')
        @set 'inactive', totals.get('inactive')
        @set 'noList', totals.get('noList')
        @set 'usersTotals', totals.get('usersTotals')
        @set 'tagsTotals', totals.get('tagsTotals')

      false

    showUsersContacts: (user) ->
      @transitionToRoute 'people.index', 'assigned_to', queryParams: user: user.get('id'), customquery: '', hidesidebar: false
      false

    showTagsContacts: (tag) ->
      @transitionToRoute 'people.index', 'tagged', queryParams: tag: tag.get('id'), customquery: '', hidesidebar: false
      false

    showCustomQueryContacts: (query) ->
      $('.query-builder-component').show()
      @set 'customquery', query.get('uid')

      @transitionToRoute 'people.index', 'dynamicquery', queryParams: customquery: query.get('uid'), hidesidebar: false

      false

    deleteCustomQuery: (query) ->
      currentUser = @get('currentUser')

      customQueryUid = query.get('uid')

      currentUser.get('customQueries').removeObject query

      currentUser.save().then =>
        @send 'flashSuccess', "Custom Query deleted"

      if @get('isQuery') && @get('customquery') == customQueryUid
        @transitionToRoute 'people.index', 'all', queryParams: customquery: '', hidesidebar: false
      false

    deleteTag: (tag) ->
      tagName = tag.get('name')
      tagId = tag.get('id')

      return unless confirm("Are you sure you want to delete the #{tagName} list?")

      tag.delete().then =>
        @send 'flashSuccess', "The tag #{tagName} has been deleted."

        @transitionToRoute "people.index", "all", queryParams: customquery: '', hidesidebar: false if @tag == tagId

        @get('controllers.application').notifyPropertyChange 'tags'

      false

    makeTagConfigurable: (tag) ->
      tag.toggleProperty('configurable')

      tag.save().then (result) ->
        return unless tag.get('configurable')

        Ember.run.next ->
          ele = $(".nav [data-tag-id=#{tag.get('id')}]")
          ele.addClass 'highlight'

          cancel = Ember.run.later ->
            ele.removeClass 'highlight'

            Ember.run.cancel cancel
          , 2000

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
  untrackedIndex: Ember.computed.oneWay 'controllers.untrackedIndex'
  companiesTotal: Ember.computed.oneWay 'controllers.addressbook.companiesTotal'

  queryParams: ['user', 'tag', 'company', 'contactimportjob', 'customquery', 'hidesidebar']
  user: null
  company: null
  contactimportjob: null
  customquery: null
  hidesidebar: false

  filter: null

  isPotential: Ember.computed.equal 'filter', 'potential'
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

  filterParams: Ember.computed 'filter', 'user', 'tag', 'company', 'contactimportjob', 'customquery', ->
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
      customquery = @get('customquery')
      Ember.assert "You must have a query query for a custom query queryParam", customquery

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
          {name: "field", value: field, static: true}
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

  resetCustomQuery: ->
    @EventBus.publish "clearQuery"

  showCustomQuery: ->
    @EventBus.publish "showQuery"

  checkedColumns: Ember.computed.filterBy 'combinedColumns', 'checked'

  checkedColumnsDidChange: Ember.observer 'checkedColumns.length', ->
    checked = @get('checkedColumns').filter((c) -> c.checked).mapProperty 'id'

    return unless checked.length

    localStorage.setItem @SAVED_COLUMNS, JSON.stringify(checked)

  displayNoContacts: Ember.computed 'noContacts', 'isPotential', 'potential', 'filter', ->
    return false if @get('isPotential')

    !!@get('noContacts')

  newCustomQueries: Ember.A()
  potentialQueries: Ember.A()
  actualQueries: []
  showContactModal: false
  modalContact: null

  closeModals: ->
    @set 'modalContact', null
    @set 'showContactModal', false

  combinedQueryFields: Ember.computed 'customFields.[]', ->
    queryFields = @queryFields
    customFields = @get('customFields') || []

    return queryFields unless customFields.get('length')

    customFieldOperatorMap =
      "text": "text"
      "currency": "number"
      "url": "text"

    customFieldsMapping = customFields.toArray().reject((f) -> f.get('type') == 'date')
                                      .map (f) ->
                                              field: f.get('name')
                                              displayName: f.get('name')
                                              operatorType: customFieldOperatorMap[f.get('type')]
                                              customfieldid: f.get('id')

    queryFields.concat customFieldsMapping

  queryFields: [
    {
      field: "name"
      displayName: "Name"
      operatorType: "text"
    }
    {
      field: "email"
      displayName: "Email"
      operatorType: "text"
    }
    {
      field: "company"
      displayName: "Company"
      operatorType: "text"
    }
    {
      field: "city"
      displayName: "City"
      operatorType: "text"
    }
    {
      field: "events"
      displayName: "Events"
      operatorType: "number"
    }
    {
      field: "inactive"
      displayName: "Inactive"
      operatorType: "number"
    }
    {
      field: "contact_status"
      displayName: "Contact Status"
      operatorType: "text"
    }
    {
      field: "source"
      displayName: "Source"
      operatorType: "text"
    }
    {
      field: "assigned_to"
      displayName: "Assigned To"
      operatorType: "user"
    }
    {
      field: "deals_closed"
      displayName: "Deals Closed"
      operatorType: "number"
    }
    {
      field: "next_task"
      displayName: "Next Task"
      operatorType: "boolean"
    }
    {
      field: "activity_seven_days_total"
      displayName: "Activities in the last 7 days"
      operatorType: "number"
    }
    {
      field: "activity_thirty_days_total"
      displayName: "Activities in the last 30 days"
      operatorType: "number"
    }
  ]
