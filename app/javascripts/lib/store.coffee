DS.RadiumStore = DS.Store.extend
  revision: 4
  adapter: DS.FixtureAdapter.create
    plurals: {}
    pluralize: (name) ->
      @plurals[name] || name + "s"
