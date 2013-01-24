require 'radium/adapters/fixture_adapter'

Radium.Store = DS.Store.extend
  revision: 11
  adapter: Radium.FixtureAdapter
