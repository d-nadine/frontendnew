Radium.SettingsCompanyRoute = Radium.Route.extend
  actions:
    destroyAccount: ->
      controller = @controllerFor('settingsCompany')
      controller.set('beingDestroyed', true)

      account = @controllerFor('account').get('model')

      account.deleteRecord()

      errorHandler = (result) =>
        @send 'close'
        @send 'flashError', 'An error has occurred and the caccount cannot be deleted.'

      account.delete().then =>
        apiUrl = @get('store').get('_adapter.url')
        Radium.get('authManager').logOut(apiUrl)

      account.one 'becameInvalid', errorHandler
      account.one 'becameError', errorHandler

      @get('store').commit()

    deleteUser: (user) ->
      c = confirm("Are you sure you want to delete #{user.get('name')}? This cannot be undone")

      return unless c

      user.delete().then =>
        @send 'flashSuccess', "User has been deleted."

    resendInvite: (user) ->
      details = user.getProperties('name', 'email')
      details.invitedAt = Ember.DateTime.create()
      resend = Radium.ResendUserInvite.createRecord(details)
      resend.save().then (item) =>
        @send('didResendInvite', item.get('email'))

    didResendInvite: (email) ->
      alert "Did resend invite to #{email}"

  model: ->
    Radium.UserInvitation.find()

  setupController: (controller, model) ->
    this.controllerFor('usersInvites').set('content', model)
