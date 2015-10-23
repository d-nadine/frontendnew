Radium.ListsService = Ember.Object.extend
  lists: Ember.A()

  refresh: ->
    Radium.List.find({}).then (results) =>
      @set 'lists', results.toArray().slice()

    @notify()

  sortedLists: Ember.computed.sort 'lists', (a, b) ->
    Ember.compare a.get('name'), b.get('name')

  notify: ->
    @notifyPropertyChange 'lists'
    @notifyPropertyChange 'sortedLists'

  addList: (list) ->
    @get('lists').pushObject(list)
    @notify()

  removeList: (list) ->
    @get('lists').removeObject(list)
    @notify()
