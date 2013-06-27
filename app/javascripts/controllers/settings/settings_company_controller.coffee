Radium.SettingsCompanyController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users', 'usersInvites']
  users: Ember.computed.alias 'controllers.users'
  pendingUsers: Ember.computed.alias 'controllers.usersInvites'
  didReInvite: false

  cancelInvite: (invite) ->
    invite.deleteRecord()
    @store.commit()