Ember.Application.initializer
  name: 'auth'
  after: 'adapterUrl'
  initialize: (container, application) ->
    Radium.set('authManager', Radium.AuthManager.create())

    Radium.User.find(name: 'me').then (records) ->
      user = records.get('firstObject')

      application.register('current:user', user, instantiate: false, singleton: true)

      application.inject 'component', 'currentUser', 'current:user'
      application.inject 'controller', 'currentUser', 'current:user'
      application.inject 'route', 'currentUser', 'current:user'

      Radium.Form.reopen
        currentUser: user

      initImportPoller = Radium.InitialImportPoller.create
        currentUser: container.lookup('current:user')

      application.register('importpoller-service:current', initImportPoller, instantiate: false)
      application.inject('route', 'initialImportPoller', 'importpoller-service:current')

      if window.ENV.environment == "production"
        Raven.setUserContext
          id: user.get('id')
          email: user.get('email')

      window.Intercom "boot",
        app_id: window.INTERCOM_APP_ID
        email: user.get('email')
        user_id: user.get('id')
        created_at: user.get('createdAt').toUnixTimestamp()
        widget:
          activator: "#IntercomDefaultWidget"
        increments:
          number_of_clicks: 1

      $.cloudinary.config({ cloud_name: 'radium', api_key: '472523686765267'})
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
        store = container.lookup('store:main')

        Ember.assert "you need a store in the container of the auth initializer", store

        apiUrl = store.get('_adapter.url')
        Radium.get('authManager').logOut(apiUrl, "#{apiUrl}/sessions/new")
      else
        Ember.$('[class^=ball]').hide()
        Radium.advanceReadiness()

        return if Ember.ENV.environment != "production" || location.pathname != "/"

        Ember.run.next ->
          router = container.lookup('router:main')
          router.replaceWith "people.contacts"
