require 'radium/adapters/fixture_adapter'

Radium.Store = DS.Store.extend
  revision: 9

  expandableArrayFor: (type) ->
    recordArray = Radium.ExpandableRecordArray.create
      type: type
      content: Ember.A([])
      store: this

  isInStore: (type, id) ->
    !!@typeMapFor(type).idToCid[id]

  adapter: Radium.FixtureAdapter
