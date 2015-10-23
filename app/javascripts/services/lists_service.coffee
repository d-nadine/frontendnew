Radium.ListsService = Ember.Object.extend
  lists: Ember.A()

  refresh: ->
    Radium.List.find({}).then (results) =>
      @set 'lists', results.toArray().slice()

    @notify()

  sortedLists: Ember.computed.sort 'lists', (a, b) ->
    Ember.compare a.get('name'), b.get('name')

  configurableLists: Ember.computed 'sortedLists.@each.configurable', ->
    @get('lists').filter (list) -> list.get('configurable')

  notify: ->
    @notifyPropertyChange 'lists'
    @notifyPropertyChange 'sortedLists'
    @notifyPropertyChange 'configurableLists'

  addList: (list) ->
    @get('lists').pushObject(list)
    @notify()

  removeList: (list) ->
    @get('lists').removeObject(list)
    @notify()
