Radium.SettingsCompanyRoute = Radium.Route.extend
  actions:
    confirmDestroyAccount: ->
      controller = @controllerFor('settingsDestroyAccountConfirmation')

      controller.set('model', @controllerFor('account').get('model'))
      @render 'settings/destroy_account_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    destroyAccount: ->
      controller = @controllerFor('settingsDestroyAccountConfirmation')
      controller.set('beingDestroyed', true)

      account = controller.get('model')

      account.deleteRecord()

      errorHandler = (result) =>
        @send 'close'
        @send 'flashError', 'An error has occurred and the caccount cannot be deleted.'

      account.one 'didDelete', =>
        apiUrl = @get('store').get('_adapter.url')
        Radium.get('authManager').logOut(apiUrl)

      account.one 'becameInvalid', errorHandler
      account.one 'becameError', errorHandler

      @get('store').commit()

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
  model: ->
    Radium.UserInvitation.find()

  setupController: (controller, model) ->
    this.controllerFor('usersInvites').set('content', model)
