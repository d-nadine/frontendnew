Ember.Application.initializer
  name: 'auth'
  after: 'store'
  initialize: (container, application) ->
    Radium.set('authManager', Radium.AuthManager.create())

    errHandler = (e) ->
      # location.replace('http://api.radiumcrm.com/sessions/new')
      # Ember.Logger.error e
      # console.error 'The "me" user was not found for some reason!'
      # throw e

    Radium.User.find(name: 'me').then(((records) ->
      user = records.get('firstObject')

      currentUserController = container.lookup('controller:currentUser')
      currentUserController.set 'model', user

      window.Intercom "boot",
        app_id: Radium.get('intercomAppId')
        email: user.get('email') 
        user_id: user.get('id')
        created_at: user.get('createdAt').toUnixTimestamp()
        widget:
          activator: "#IntercomDefaultWidget"
        increments:
          number_of_clicks: 1

      account = user.get('account')

      userSettingsController = container.lookup('controller:userSettings')
      userSettingsController.set('model', user.get('settings'))

      accountController = container.lookup('controller:account')
      accountController.set('model', user.get('account'))

      accountSettingsController = container.lookup('controller:accountSettings')
      accountSettingsController.set('model', user.get('account'))

      billingController = container.lookup('controller:settingsBilling')
      billingController.set('model', user.get('account.billing'))

      # we need to get the user to grant access if it has been revoked
      if user.get('refreshFailed')
        store = currentUserController.get('store')

        apiUrl = store.get('_adapter.url')
        Radium.get('authManager').logOut(apiUrl, "#{apiUrl}/sessions/new")
      else
        Ember.$('[class^=ball]').hide()
        Radium.advanceReadiness()
    ), errHandler).then(null, errHandler)
