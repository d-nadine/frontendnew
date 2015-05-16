Radium.UserItemComponent = Ember.Component.extend
  classNameBindings: ['isCurrent:active']
  actions:
    showUsersContacts: ->
      @get('parent').send "showUsersContacts", @get('user')

      false

  isAssignedTo: Ember.computed.oneWay 'parent.isAssignedTo'
  usersTotals: Ember.computed.oneWay 'parent.usersTotals'
  display: Ember.computed 'user', ->
    "@#{@get('user.name')}"

  isCurrent: Ember.computed 'parent.user', 'isAssignedTo', 'user', ->
    return unless @get('isAssignedTo') && @get('user')

    @get('user.id') == @get('parent.user')

  contactsTotal: Ember.computed 'parent.user', 'usersTotals', ->
    unless usersTotals = @get('usersTotals')
      return

    unless userId = @get('user.id')
      return

    usersTotals.find((user) -> user.id == parseInt(userId)).total
