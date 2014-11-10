Radium.PeopleIndexController = Radium.ArrayController.extend Radium.CheckableMixin,
  actions:
    showMore: ->
      alert 'hoor'

    sortContacts: (prop, ascending) ->
      model = @get("model")
      params = model.get("params")

      delete params.sort_properties
      sort_properties = "sort_properties": JSON.stringify([{"property": prop, "asc": ascending}])

      params = Ember.merge sort_properties, params

      model.set 'params', params
      false

  filter: null

  searchText: "",
  filterParams: Ember.observer "searchText", ->
    return if filter is null

    filter = @get('filter')
    params = @get('paramsMap')[filter]

    searchText = Ember.$.trim(@get('searchText'))

    params = Ember.merge params, like: searchText

    @get("model").set("params", params)

  paramsMap:
    all:
      public: true
