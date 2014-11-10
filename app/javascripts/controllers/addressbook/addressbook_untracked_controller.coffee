Radium.AddressbookUntrackedController = Ember.ArrayController.extend({
  searchText: "",
  filterParams: Ember.observer "searchText", ->
    #TODO: loading state
    @get("model").set("params", {private: true, like: @get("searchText")})
})
