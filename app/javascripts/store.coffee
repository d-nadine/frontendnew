require 'adapters/fixture_adapter'
require 'adapters/rest_adapter'

Adapter = Radium.RESTAdapter.extend
            url: 'http://4apz.localtunnel.com'

Radium.Store = DS.Store.extend
  revision: 12
  adapter: Adapter
