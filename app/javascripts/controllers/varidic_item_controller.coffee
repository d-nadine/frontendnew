Radium.VaridicItemController = Radium.ObjectController.extend
  needs: ['users', 'contactStatuses']
  users: Ember.computed.oneWay 'controllers.users'
  contactStatuses: Ember.computed.oneWay 'controllers.contactStatuses'

  assignedTo: Ember.computed.alias 'user'
  contact: Ember.computed.alias 'model'

  availableStatuses: Ember.computed 'contactStatuses.[]', 'contactStatus', ->
    @get('contactStatuses').reject (status) =>
      status == @get('contactStatus')

  assignees: Ember.computed 'users.[]', 'user', ->
    @get('users').reject (user) =>
      user == @get('user')

  isSaving: false