require 'adapters/fixture_adapter'
require 'adapters/rest_adapter'

Radium.Store = DS.Store.extend
  revision: 12
  adapter: Radium.RESTAdapter.extend
    url: 'http://42ru.localtunnel.com'
