Radium.SettingsCompanyController = Radium.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users', 'usersInvites', 'account']
  account: Ember.computed.alias 'controllers.account.model'
  companyName: Ember.computed.alias 'controllers.account.name'
  users: Ember.computed.alias 'controllers.users'
  pendingUsers: ( ->
    @get('controllers.usersInvites').filter (invite) ->
      !invite.get('confirmed') && !invite.get('isError') && !invite.get("isNew")
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
