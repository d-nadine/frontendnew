Radium.PeopleIndexController = Radium.ArrayController.extend Radium.CheckableMixin,
  actions:
    updateTotals: ->
      Radium.ContactsTotals.find({}).then (results) =>
        totals = results.get('firstObject')
        @set 'all', totals.get('all')
        @set 'new', totals.get('new')
        @set 'noTasks', totals.get('noTasks')
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

  isAssignedTo: Ember.computed.equal 'filter', 'assigned_to'

  filterParams: Ember.computed 'filter', 'user', ->
    params =
      public: true
      filter: @get('filter')
      page_size: @get('pageSize')

    unless user = @get('user') && @get('isAssignedTo')
      return params

    Ember.merge params, user: @get('user')

  searchDidChange: Ember.observer "searchText", ->
    return if filter is null

    filter = @get('filter')
    params = @get('paramsMap')[filter]

    searchText = Ember.$.trim(@get('searchText'))

    params = Ember.merge params, like: searchText, page_size: @get('pageSize')

    @get("model").set("params", params)

  pageSize: 25

  paramsMap:
    all:
      public: true
