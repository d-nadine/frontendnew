Radium.AddressbookPeopleController = Radium.ArrayController.extend
  actions:
    sortContacts: (prop, ascending) ->
      model = @get("model")
      params = model.get("params")

      delete params.sort_properties
      sort_properties = "sort_properties": JSON.stringify([{"property": prop, "asc": ascending}])

      params = Ember.merge sort_properties, params

      model.set 'params', params
      false

  searchText: "",
  filterParams: Ember.observer "searchText", ->
    @get("model").set("params", {public: true, like: @get("searchText")})
