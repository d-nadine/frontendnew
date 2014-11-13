Radium.PeopleIndexController = Radium.ArrayController.extend Radium.CheckableMixin,
  actions:
    updateTotals: ->
      Radium.ContactsTotals.find({}).then (results) =>
        totals = results.get('firstObject')
        @set 'all', totals.get('all')
        @set 'new', totals.get('new')
        @set 'noTasks', totals.get('noTasks')
        @set 'inactive', totals.get('inactive')
        @set 'noList', totals.get('noList')
        @set 'usersTotals', totals.get('usersTotals')

    showUsersContacts: (user) ->
      @transitionToRoute 'people.index', 'assigned_to', queryParams: user: user.get('id')
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

  queryParams: ['user']
  user: null

  filter: null

  searchText: ""

  isAll: Ember.computed.equal 'filter', 'all'
  isNew: Ember.computed.equal 'filter', 'new'
  isNoTasks: Ember.computed.equal 'filter', 'notasks'
  isLosing: Ember.computed.equal 'filter', 'losing'
  isNoList: Ember.computed.equal 'filter', 'no_list'

  isAssignedTo: Ember.computed.equal 'filter', 'assigned_to'

  filterParams: Ember.computed 'filter', 'user', ->
    params =
      public: true
      filter: @get('filter')
      page_size: @get('pageSize')

    unless user = @get('user') && @get('isAssignedTo')
      return params

    Ember.merge params, user: @get('user')

  noResults: Ember.computed 'content.isLoading', 'model.[]', ->
    not @get('content.isLoading') && not @get('model').get('length')

  searchDidChange: Ember.observer "searchText", ->
    return if @get('filter') is null

    searchText = @get('searchText')

    filterParams = @get('filterParams')

    params = Ember.merge filterParams, like: searchText

    @get("content").set("params", Ember.copy(params))

  pageSize: 25
