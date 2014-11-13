Radium.PeopleUserItemController = Radium.ObjectController.extend
  isAssignedTo: Ember.computed.oneWay 'parentController.isAssignedTo'
  user: Ember.computed.oneWay 'parentController.user'
  usersTotals: Ember.computed.oneWay 'parentController.usersTotals'
  display: Ember.computed 'name', ->
    "@#{@get('name')}"

  isCurrent: Ember.computed 'model', 'isAssignedTo', 'user', ->
    return unless @get('isAssignedTo') && @get('user')

    @get('model.id') == @get('user')

  contactsTotal: Ember.computed 'model', 'usersTotals', ->
    unless usersTotals = @get('usersTotals')
      return

    unless userId = @get('model.id')
      return

    usersTotals.find((user) -> user.id == parseInt(userId)).total