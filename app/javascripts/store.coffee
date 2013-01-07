require 'radium/adapters/fixture_adapter'

Radium.Store = DS.Store.extend
  revision: 9

  # TODO: remove this code
  isInStore: (type, id) ->
    !!@typeMapFor(type).idToCid[id]

  adapter: Radium.FixtureAdapter
