require 'adapters/fixture_adapter'
require 'adapters/rest_adapter'

Radium.Store = DS.Store.extend
  revision: 13
  adapter: Radium.RESTAdapter.extend
    url: 'http://localhost:9292'
    bulkCommit: false
