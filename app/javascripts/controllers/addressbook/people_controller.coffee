Radium.PeopleIndexController = Radium.ArrayController.extend Radium.CheckableMixin,
  Radium.ContactColumnsConfig,
  actions:
    saveTag: (newTag) ->
      tagNames = @get('tags').mapProperty('name').map((name) -> name.toLowerCase()).toArray()

      if tagNames.contains(newTag.get('name').toLowerCase())
        @send 'flashError', 'A list with this name already exists.'
        return

      tag = Radium.Tag.createRecord(name: newTag.get('name'), account: @get('currentUser.account'))

      tag.one 'didCreate', =>
        @get('newTags').removeObject newTag

        @send 'flashSuccess', "New list successfully created."

        Radium.Tag.find({})

        @send 'updateTotals'

      tag.one 'becameInvalid', =>
        @send "flashError", tag

      tag.one 'becameError', =>
        @send "flashError", "An error has occurred and the new list cannot be created."

      @get('store').commit()

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

    saveEmail: (context) ->
      unless context.get('model.email')
        email = context.get('bufferedProxy.email')
        context.get('bufferedProxy').discardBufferedChanges()

        context.get('model.emailAddresses').createRecord
                         name: 'work'
                         value: email
                         isPrimary: true

    savePhone: (context) ->
      unless context.get('model.phone')
        phone = context.get('bufferedProxy.phone')
        context.get('bufferedProxy').discardBufferedChanges()

        context.get('model.phoneNumbers').createRecord
                         name: 'work'
                         value: phone
                         isPrimary: true

    addTag: (tag) ->
      @send "executeActions", "tag", tag: tag
      false

    assignAll: (user) ->
      @send "executeActions", "assign", user: user
      false

    deleteAll: ->
      @send "executeActions", "delete"
      false

    executeActions: (action, detail) ->
      checkedContentb = @get('checkedContent')
      allChecked = @get('allChecked')

      unless allChecked || checkedContent.length
        return @send 'flashError', "You have not selected any contacts."

      if action == "compose"
        return @transitionToRoute 'emails.new', "inbox", queryParams: bulkEmail: true

      @set 'working', true

      unless allChecked
        ids = checkedContent.mapProperty('id')
        filter = null
      else
        ids = []
        filter = @get('filter')

      job = Radium.BulkActionsJob.createRecord
             action:  action
             ids: ids
             public: true
             filter: filter

      searchText = $.trim(@get('searchText') || '')

      if searchText.length
        job.set 'like', searchText

      if action == "tag"
        job.set('newTags', Ember.A([detail.tag.id]))
      else if action == "assign"
        job.set('assignedTo', detail.user)

      if @get('tag') && @get('isTagged')
        tag = Radium.Tag.all().find (t) => t.get('id') == @get('tag')
        job.set('tag', tag)

      if @get('user') && @get('isAssignedTo')
        user = Radium.User.all().find (u) => u.get('id') == @get('user')
        job.set 'user', user

      job.one 'didCreate', =>
        @set 'working', false
        @send 'flashSuccess', 'The records have been updated.'
        @send 'updateLocalRecords', job
        @send 'updateTotals'

        return unless action == "delete"
        @get('controllers.addressbook').send 'updateTotals'

      job.one 'becameError', =>
        @set 'working', false
        @send 'flashError', 'An error has occurred and the operation could not be completed.'

      @get('store').commit()

    updateLocalRecords: (job) ->
      ids = @get('checkedContent').mapProperty 'id'
      action = job.get('action')

      store = @get('store')
      serializer = @get('store._adapter.serializer')
      loader = DS.loaderFor(store)
      dataset = @get('model')

      ids.forEach (id) ->
        contact = Radium.Contact.all().find (c) -> c.get('id') + '' == id

        if contact
          if action == "delete"
            contact.unloadRecord()
            dataset.removeObject contact
          else
            data = contact.get('_data')
            if action == "assign"
              return contact.updateLocalBelongsTo 'assignedTo', job.get('assignedTo')

            if action == "tag"
              references = data.tags.map((tag) -> {id: tag.id, type: Radium.Tag})
              newTagId = job.get('newTags.firstObject')
              tag = Radium.Tag.all().find (t) -> t.get('id') == newTagId

              unless references.any((tag) -> tag.id == newTagId)
                references.push id: newTagId, type: Radium.Tag

                tagName = serializer.extractRecordRepresentation(loader, Radium.TagName, {name: tag.get('name')})
                tagName.parent = contact.get('_reference')
                data.tagNames.push tagName

              references = contact._convertTuplesToReferences(references)
              data['tags'] = references


            contact.set('_data', data)

            contact.suspendRelationshipObservers ->
              contact.notifyPropertyChange 'data'

            contact.updateRecordArrays()

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

    showMore: ->
      return if @get('content.isLoading')
      @get('model').expand()

    sortContacts: (prop, ascending) ->
      model = @get("model")
      params = model.get("params")

      delete params.sort_properties
      sort_properties = "sort_properties": JSON.stringify([{"property": prop, "asc": ascending}])

      params = Ember.merge sort_properties, params

      model.set 'params', params
      false

  needs: ['addressbook', 'users', 'tags']

  users: Ember.computed.oneWay 'controllers.users'
  tags: Ember.computed.oneWay 'controllers.tags'

  queryParams: ['user', 'tag']
  user: null

  filter: null

  searchText: ""

  isAll: Ember.computed.equal 'filter', 'all'
  isNew: Ember.computed.equal 'filter', 'new'
  isNoTasks: Ember.computed.equal 'filter', 'notasks'
  isLosing: Ember.computed.equal 'filter', 'losing'
  isNoList: Ember.computed.equal 'filter', 'no_list'
  isTagged: Ember.computed.equal 'filter', 'tagged'
  isAssignedTo: Ember.computed.equal 'filter', 'assigned_to'

  newTags: Ember.A()

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

    usersTotals.find((user) -> user.id == parseInt(userId)).total

  team: Ember.computed 'currentUser', 'users.[]', ->
    currentUser = @get('currentUser')

    @get('users').reject (user) -> user == currentUser

  filterParams: Ember.computed 'filter', 'user', 'tag', ->
    params =
      public: true
      filter: @get('filter')
      page_size: @get('pageSize')

    if user = @get('user') && @get('isAssignedTo')
      return Ember.merge params, user: @get('user')

    if tag = @get('tag') && @get('isTagged')
      return Ember.merge params, tag: @get('tag')

    params

  noResults: Ember.computed 'content.isLoading', 'model.[]', ->
    not @get('content.isLoading') && not @get('model').get('length')

  searchDidChange: Ember.observer "searchText", ->
    return if @get('filter') is null

    searchText = @get('searchText')

    filterParams = @get('filterParams')

    params = Ember.merge filterParams, like: searchText

    @get("content").set("params", Ember.copy(params))

  pageSize: 25

  checkedColumns: Ember.computed.filterBy 'columns', 'checked'

  totalRecords: Ember.computed 'content.source.content.meta', ->
    @get('content.source.content.meta.totalRecords')

  checkedTotal: Ember.computed 'totalRecords', 'checkedContent.length', 'allChecked', 'working', ->
    if @get('allChecked')
      @get('totalRecords')
    else
      @get('checkedContent.length')
