require 'radium/adapters/in_memory_adapter'

Radium.Store = DS.Store.extend
  revision: 11
  adapter: Radium.InMemoryAdapter
