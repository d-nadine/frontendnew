Radium.ListsController = Radium.Controller.extend
  sortedLists: Ember.computed.sort 'lists', (a, b) ->
    Ember.compare a.get('name'), b.get('name')
