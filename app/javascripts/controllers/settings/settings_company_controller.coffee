Radium.SettingsCompanyController = Radium.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users', 'usersInvites']
  users: Ember.computed.alias 'controllers.users'
  pendingUsers: ( ->
    @get('controllers.usersInvites').filter (invite) ->
      !invite.get('confirmed') || !invite.get('isNew') || !invite.get('isError')
  ).property('controllers.usersInvites.[]')

  resendInvite: (invite) -> 
    invitation = Radium.UserInvitationDelivery.createRecord
                  userInvitation: invite

    invitation.one 'didCreate', =>
      @send 'flashSuccess', 'invitation resent'

    invitation.one 'becameInvalid', (result) =>
      invitation.get('transaction').rollback()
      @send 'flashError', result

    invitation.one 'beameError', (result) =>
      invitation.get('transaction').rollback()
      @send 'flashError', 'An error occurred and the invitation could not be sent'

    @get('store').commit()

  cancelInvite: (invite) ->
    invite.deleteRecord()
    @store.commit()
    @send 'flashSuccess', 'The invite has been cancelled'
