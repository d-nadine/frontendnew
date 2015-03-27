require "controllers/addressbook/people_mixin"

Radium.PeopleIndexController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.ContactColumnsConfig,
  actions:
    unTrackAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "untrack", detail
      false

    localUntrack: (contact, dataset) ->
      Ember.run.next =>
        @get('model').removeObject contact
        @get('controllers.untrackedIndex.model').pushObject contact
        contact.set 'isChecked', false

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

    deleteTag: (tag) ->
      tagName = tag.get('name')
      tagId = tag.get('id')

      tag.delete(this).then =>
        @send 'flashSuccess', "The tag #{tagName} has been deleted."

        @transitionToRoute "people.index", "all" if @tag == tagId

      false

  needs: ['addressbook', 'users', 'tags', 'contactStatuses', 'company', 'untrackedIndex']

  noContacts: Ember.computed.oneWay 'controllers.addressbook.noContacts'

  users: Ember.computed.oneWay 'controllers.users'
  tags: Ember.computed.oneWay 'controllers.tags'
  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'
  contactsTotal: Ember.computed.oneWay 'controllers.addressbook.contactsTotal'

  queryParams: ['user', 'tag', 'company', 'contactimportjob']
  user: null
  company: null
  contactimportjob: null

  filter: null

  isAll: Ember.computed.equal 'filter', 'all'
  isNew: Ember.computed.equal 'filter', 'new'
  isNoTasks: Ember.computed.equal 'filter', 'notasks'
  isLosing: Ember.computed.equal 'filter', 'losing'
  isNoList: Ember.computed.equal 'filter', 'no_list'
  isTagged: Ember.computed.equal 'filter', 'tagged'
  isAssignedTo: Ember.computed.equal 'filter', 'assigned_to'

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

    params

  noResults: Ember.computed 'content.isLoading', 'model.[]', ->
    not @get('content.isLoading') && not @get('model').get('length')

  pageSize: 25

  checkedColumns: Ember.computed.filterBy 'columns', 'checked'

  checkedColumnsDidChange: Ember.observer 'checkedColumns.length', ->
    checked = @get('checkedColumns').filter((c) -> c.checked).mapProperty 'id'
    localStorage.setItem @SAVED_COLUMNS, JSON.stringify(checked)
