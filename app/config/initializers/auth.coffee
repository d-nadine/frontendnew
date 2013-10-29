Ember.Application.initializer
  name: 'auth'
  after: 'store'
  initialize: (container, application) ->
    Radium.set('authManager', Radium.AuthManager.create())

    errHandler = (e) =>
      # location.replace('http://api.radiumcrm.com/sessions/new')
      # Ember.Logger.error e
      # console.error 'The "me" user was not found for some reason!'
      # throw e

    Radium.User.find(name: 'me').then(((records) =>
      user = records.get('firstObject')

      currentUserController = container.lookup('controller:currentUser')
      currentUserController.set 'model', user

      window.Intercom "boot",
        app_id: "d5bd1654e902b81ba0f4161ea5b45bb597bfefdf"
        email: user.get('email') 
        user_id: user.get('id')
        created_at: user.get('createdAt').toUnixTimestamp()
        number_of_contacts: 0
        widget:
          activator: "#IntercomDefaultWidget"

      account = user.get('account')

      userSettingsController = container.lookup('controller:userSettings')
      userSettingsController.set('model', user.get('settings'))

      accountController = container.lookup('controller:account')
      accountController.set('model', user.get('account'))

      accountSettingsController = container.lookup('controller:accountSettings')
      accountSettingsController.set('model', user.get('account'))

      Ember.$('[class^=ball]').hide()
      Radium.advanceReadiness()
    ), errHandler).then(null, errHandler)
