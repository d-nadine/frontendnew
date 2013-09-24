require 'adapters/fixture_adapter'
require 'adapters/rest_adapter'

Radium.Store = DS.Store.extend
  revision: 14
  adapter: Radium.RESTAdapter.extend
    bulkCommit: false
