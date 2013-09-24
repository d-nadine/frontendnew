Radium.SettingsCompanyRoute = Radium.Route.extend
  model: ->
    Radium.UserInvitation.find()

  setupController: (controller, model) ->
    this.controllerFor('usersInvites').set('content', model)

  actions:
    deleteUser: (user) ->
      c = confirm("Are you sure you want to delete #{user.get('name')}? This cannot be undone")

      user.deleteRecord() if c

    resendInvite: (user) ->
      details = user.getProperties('name', 'email')
      details.invitedAt = Ember.DateTime.create()
      resend = Radium.ResendUserInvite.createRecord(details)
      resend.one 'didCreate', (item) =>
        @send('didResendInvite', item.get('email'))

      @store.commit()

    didResendInvite: (email) ->
      alert "Did resend invite to #{email}"
