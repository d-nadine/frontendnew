Radium.PeopleIndexController = Radium.ArrayController.extend Radium.CheckableMixin,
  actions:
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

  filter: null

  searchText: ""

  isAll: Ember.computed.equal 'filter', 'all'
  isNew: Ember.computed.equal 'filter', 'new'
  isUnassigned: Ember.computed.equal 'filter', 'unassigned'
  isNoTasks: Ember.computed.equal 'filter', 'notasks'
  isAssigned: Ember.computed.equal 'filter', 'assigned'
  isLosing: Ember.computed.equal 'filter', 'losing'

  filterParams: Ember.computed 'filter', ->
    public: true
    filter: @get('filter')
    page_size: @get('pageSize')

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
