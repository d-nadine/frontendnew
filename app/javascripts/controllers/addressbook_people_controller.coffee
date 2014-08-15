  Radium.AddressbookPeopleController = Radium.ArrayController.extend
    searchText: "",
    filterParams: Ember.observer "searchText", ->
      @get("model").set("params", {public: true, like: @get("searchText")})
