require 'adapters/fixture_adapter'

Radium.Store = DS.Store.extend
  revision: 12
  adapter: Radium.FixtureAdapter
