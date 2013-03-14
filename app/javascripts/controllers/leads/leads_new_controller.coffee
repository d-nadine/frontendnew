Radium.LeadsNewController= Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['contacts']
  contacts: Ember.computed.alias 'controllers.contacts'
  selectedContact: null
  assignedTo: null
  init: ->
    @_super.apply this, arguments
    @set 'assignedTo', @get('currentUser')
