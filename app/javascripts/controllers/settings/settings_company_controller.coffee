Radium.SettingsCompanyController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users', 'usersInvites']
  users: Ember.computed.alias 'controllers.users'
  pendingUsers: ( ->
    @get('controllers.usersInvites').filter (invite) ->
      !invite.get('isNew') || !invite.get('isError')
  ).property('controllers.usersInvites.[]')

  didReInvite: false

  cancelInvite: (invite) ->
    invite.deleteRecord()
    @store.commit()
