Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts', 'users']
  contacts: Ember.computed.alias 'controllers.contacts'
  users: Ember.computed.alias 'controllers.users'
  selectedContact: null
  assignedTo: null
  init: ->
    @_super.apply this, arguments
    @set 'assignedTo', @get('currentUser')
