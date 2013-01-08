require 'radium/adapters/fixture_adapter'

Radium.Store = DS.Store.extend
  revision: 9
  adapter: Radium.FixtureAdapter
