  Radium.AddressbookPeopleController = Ember.ArrayController.extend({
    searchText: "",
    filterParams: Ember.observer "searchText", ->
      #TODO: loading state
      @get("model").set("params", {public: true, like: @get("searchText")})
  })
