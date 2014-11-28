Radium.PeopleIndexController = Radium.ArrayController.extend Radium.CheckableMixin,
  actions:
    addTag: (tag) ->
      @send "executeActions", "tag", tag: tag
      return false

    assignAll: (user) ->
      @send "executeActions", "assign", user: user
      return false

    executeActions: (action, detail) ->
      checkedContent = @get('checkedContent')
      allChecked = @get('allChecked')

      unless allChecked || checkedContent.length
        return @send 'flashError', "You have not selected any contacts."

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

      if action == "tag"
        job.set('newTags', Ember.A([detail.tag.id]))
      else if action == "assign"
        job.set('user', detail.user)

      if @get('tag') && @get('isTagged')
        tag = Radium.Tag.all().find (t) => t.get('id') == @get('tag')
        job.set('tag', tag)

      job.one 'didCreate', =>
        @send 'flashSuccess', 'The records have been updated.'
        if ids.length
          Radium.Contact.find ids: ids
        @send 'updateTotals'

      job.one 'becameError', =>
        @send 'flashError', 'An error has occurred and the operation could not be completed.'

      @get('store').commit()

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
      model = @get('model')
      Ember.run.throttle model, model.expand, 300

    sortContacts: (prop, ascending) ->
      model = @get("model")
      params = model.get("params")

      delete params.sort_properties
      sort_properties = "sort_properties": JSON.stringify([{"property": prop, "asc": ascending}])

      params = Ember.merge sort_properties, params

      model.set 'params', params
      false

  needs: ['users', 'tags']

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

  isAssignedTo: Ember.computed.equal 'filter', 'assigned_to'

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

  showMoreMenu: Ember.computed 'team.[]', ->
    @get('team.length')

  checkedColumns: Ember.computed.filterBy 'columns', 'checked'

  fixedColumns: Ember.A([
    {
      classNames: "name"
      heading: "Name"
      route: "contact"
      binding: "name"
      avatar: true
      checked: true
      sortOn: "name"
    }
  ])

  columns: Ember.A([
    {
      classNames: "email"
      heading: "Email"
      route: "contact"
      binding: "email"
      checked: true
      sortOn: "email"
    }
    {
      classNames: "company"
      heading: "Company"
      route: "company"
      binding: "company.name"
      context: "company"
      checked: true
      sortOn: "company"
    }
    {
      classNames: "events"
      heading: "Events"
      binding: "activityTotal"
      checked: true
      sortOn: "activity_total"
    }
    {
      classNames: "inactive"
      heading: "Inactive"
      binding: "daysInactive"
      checked: true
      sortOn: "last_activity_at"
    }
    {
      classNames: "nextTask"
      heading: "Next Task"
      binding: "nextTodo.description"
      route: "calendar.task"
      context: "nextTodo"
      checked: true
    }
    {
      classNames: "assign"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: ["assignedTo", "assignees", "contact"]
      checked: true
    }
    {
      classNames: "city"
      heading: "City"
      binding: "primaryAddress.city"
      sortOn: "city"
    }
    {
      classNames: "source"
      heading: "Source"
      binding: "source"
      sortOn: "source"
    }
    {
      classNames: "added"
      heading: "Added"
      binding: "added"
      sortOn: "created_at"
    }
    {
      classNames: "deals-closed-total"
      heading: "Deals Closed"
      binding: "dealsClosedTotal"
      sortOn: "deals_closed_total"
    }
    {
      classNames: "deals-total"
      heading: "Deals Total"
      binding: "dealsTotal"
      sortOn: "deals_closed_total_value"
    }
    {
      classNames: "status"
      heading: "Status"
      binding: "status"
      sortOn: "status"
    }
    {
      classNames: "events-seven"
      heading: "Events in last 7 days"
      binding: "activitySevenDaysTotal"
      sortOn: "activity_seven_days_total"
    }
    {
      classNames: "events-thirty"
      heading: "Events in last 30 days"
      binding: "activityThirtyDaysTotal"
      sortOn: "activity_thirty_days_total"
    }
  ])