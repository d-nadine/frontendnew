Radium.VariadicItemController = Radium.ObjectController.extend
  needs: ['users']
  users: Ember.computed.oneWay 'controllers.users'
  contactStatuses: Ember.computed.oneWay 'parentController.targetObject.contactStatuses'

  assignedTo: Ember.computed.alias 'user'
  contact: Ember.computed.alias 'model'

  availableStatuses: Ember.computed 'contactStatuses.[]', 'contactStatus', ->
    return unless contactStatuses = @get('contactStatuses')

    contactStatuses.reject (status) =>
      status == @get('contactStatus')

  assignees: Ember.computed 'users.[]', 'user', ->
    @get('users').reject (user) =>
      user == @get('user')

  isSaving: false
