Radium.PeopleUserItemController = Radium.ObjectController.extend
  peopleController: Ember.computed.oneWay 'parentController'
  isAssignedTo: Ember.computed.oneWay 'parentController.isAssignedTo'
  user: Ember.computed.oneWay 'parentController.user'

  isCurrent: Ember.computed 'model', 'isAssignedTo', 'user', ->
    return unless @get('isAssignedTo') && @get('user')

    @get('model.id') == @get('user')