require "controllers/addressbook/people_mixin"
require "mixins/save_contact_actions"

Radium.PeopleIndexController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.ContactColumnsConfig,
  Radium.SaveContactActions,
  actions:
    selectContact: (item) ->
      if typeof item == "string"
        @set 'searchText', item
        $('.as-results').html('').hide()
        return false

      return unless contact = item.get('person')

      if !contact.get('isPublic') && !contact.get('potentialShare')
        contact.set('potentialShare', true)

        contact.save().then =>
          @send 'updateTotals'


      @send 'showContactDrawer', contact

      false

    confirmDeletion: ->
      unless @get('allChecked') || @get('checkedContent.length')
        return @flashMessenger.error "You have not selected any items."

      @set "showDeleteConfirmation", true

      false

    showContactDrawer: (contact) ->
      @closeDrawer()

      customFieldMap = contact.getCustomFieldMap(@get('customFields'))

      contact.set 'customFieldMap', customFieldMap

      @set 'drawerModel', contact

      config = {
        bindings: [{
          name: "contact",
          value: "drawerModel"
        },
        {
          name: "lists",
          value: "lists"
        }
        {
          name: "closeDrawer",
          value: "closeAddressbookDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "addList",
          value: "addContactList",
          static: true
        },
        {
          name: "customFields",
          value: "customFields"
        },
        {
          name: "deleteContact",
          value: "deleteContact",
          static: true
        }
        ]
        component: 'x-contact'
      }

      @set 'drawerParams', config

      @set 'showDrawer', true

      @setRowMarker(contact)

      false

    deleteContact: (contact) ->
      contactRoute = @get('contactRoute')
      contactRoute._actions['deleteRecord'].call contactRoute, contact

      false

    deleteCompany: (company) ->
      companyRoute = @get('companyRoute')
      companyRoute._actions['deleteRecord'].call companyRoute, company

      false

    showCompanyDrawer: (contact) ->
      return unless company = contact.get('company')

      @closeDrawer()

      @set "drawerModel", company

      config = {
        bindings: [{
          name: "company",
          value: "drawerModel"
        },
        {
          name: "closeDrawer",
          value: "closeAddressbookDrawer",
          static: true
        },
        {
          name: "parent",
          value: "this"
        },
        {
          name: "hideDeals",
          value: true,
          static: true
        },
        {
          name: "deleteCompany",
          value: "deleteCompany",
          static: true
        }
        ],
        component: 'x-company'
      }

      @set 'drawerParams', config

      @set 'showDrawer', true

      @setRowMarker(contact)

      false

    createList: (list) ->
      @closeModal()

      unless list
        list = Ember.Object.create
                 isNew: true
                 name: ''
                 itemName: ''
                 type: 'contacts'

      @set 'modalModel', list

      config = {
        bindings: [{
          name: "list",
          value: "modalModel"
          close: "closeModal"
          },
          {
            name: "parent",
            value: "this"
        }],
        component: 'list-editor'
      }

      @set 'modalParams', config

      @set 'showModal', true

      false

    closeModal: ->
      @closeModal()

      false

    confirmCompanyDeletion: (company) ->
      @closeDrawer()

      company.delete().then =>
        @send 'updateTotals'

      false

    closeAddressbookDrawer: ->
      @set 'showDrawer', false
      @set 'drawerModel', null
      @set 'drawerParams', null

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

    makePrivateAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "make_private", detail
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

    addList: (list) ->
      detail =
        list: list
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact

      @send "executeActions", "list", detail
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

      @set "showDeleteConfirmation", false

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
        @set 'listsTotals', totals.get('listsTotals')

      false

    showUsersContacts: (user) ->
      @transitionToRoute 'people.index', 'assigned_to', queryParams: user: user.get('id'), customquery: '', hidesidebar: false
      false

    showListsContacts: (list) ->
      @transitionToRoute 'people.index', 'listed', queryParams: list: list.get('id'), customquery: '', hidesidebar: false
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

    deleteList: (list) ->
      listName = list.get('name')
      listId = list.get('id')

      return unless confirm("Are you sure you want to delete the #{listName} list?")

      list.delete().then =>
        @send 'flashSuccess', "The list #{listName} has been deleted."

        @transitionToRoute "people.index", "all", queryParams: customquery: '', hidesidebar: false if @list == listId

        @get('controllers.application').notifyPropertyChange 'lists'

      false

<<<<<<< HEAD
    makeListConfigurable: (list) ->
      list.toggleProperty('configurable')

      list.save().then (result) ->
        return unless list.get('configurable')

        Ember.run.next ->
          ele = $(".nav [data-list-id=#{list.get('id')}]")
          ele.addClass 'highlight'

          cancel = Ember.run.later ->
            ele.removeClass 'highlight'

            Ember.run.cancel cancel
          , 2000

      false

  localMakePrivate: (contact, dataset) ->
    contact.set 'isChecked', false
    Ember.run.next =>
      @get('model').removeObject contact

  dummy: Ember.A()

  needs: ['addressbook', 'users', 'lists', 'contactStatuses', 'company', 'untrackedIndex', 'company']

  noContacts: Ember.computed.oneWay 'controllers.addressbook.noContacts'

  # UPGRADE: replace with inject
  lists: Ember.computed ->
    @container.lookup('controller:lists').get('sortedLists')

  users: Ember.computed.oneWay 'controllers.users'
  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'
  contactsTotal: Ember.computed.oneWay 'controllers.addressbook.contactsTotal'
  untrackedIndex: Ember.computed.oneWay 'controllers.untrackedIndex'
  companiesTotal: Ember.computed.oneWay 'controllers.addressbook.companiesTotal'

  queryParams: ['user', 'list', 'company', 'contactimportjob', 'customquery', 'hidesidebar']
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
  isListed: Ember.computed.equal 'filter', 'listed'
  isAssignedTo: Ember.computed.equal 'filter', 'assigned_to'
  isQuery: Ember.computed.equal 'filter', 'dynamicquery'

  public: true
  private: false

  # UPGRADE: replace with inject
  contactRoute: Ember.computed ->
    @container.lookup('route:contact')

  companyRoute: Ember.computed ->
    @container.lookup('route:company')

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

  filterParams: Ember.computed 'filter', 'user', 'list', 'company', 'contactimportjob', 'customquery', ->
    params =
      public: true
      private: false
      filter: @get('filter')
      page_size: @get('pageSize')

    if company = @get('company')
      delete params.public
      delete params.private

      params = Ember.merge params, company: @get('company')

    if contactimportjob = @get('contactimportjob')
      params = Ember.merge params, contact_import_job: @get('contactimportjob')

    if user = @get('user') && @get('isAssignedTo')
      return Ember.merge params, user: @get('user')

    if list = @get('list') && @get('isListed')
      delete params.public
      delete params.private

      return Ember.merge params, list: @get('list')

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
          {name: "parent", value: "table.targetObject"}
          {name: "customFields", value: "table.targetObject.customFields"}
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
    return false if @get('isPotential') || @get('isListed')

    !!@get('noContacts')

  setRowMarker: (contact) ->
    ['.left-table', '.right-table'].forEach (t) ->
      row = $("#{t} .variadic-table [data-model='#{contact.get('id')}']")

      row.addClass 'selected'

  newCustomQueries: Ember.A()
  potentialQueries: Ember.A()
  actualQueries: []
  showDrawer: false
  drawerModel: null
  drawerParams: null
  showDeleteConfirmation: false


  filterSearchResults: (item) ->
    true

  searchQueryParameters: (query) ->
    scopes: ['contact']
    term: query

  _initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @EventBus.subscribe "closeDrawers", this, @closeDrawer.bind(this)

  closeDrawer: ->
    @set 'showDrawer', false
    @set 'drawerModel', null
    @set 'drawerParams', null

  closeModal: ->
    @set 'showModal', false
    @set 'modalModel', false
    @set 'modalParams', false

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
