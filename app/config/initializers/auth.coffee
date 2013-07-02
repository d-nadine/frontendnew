Ember.Application.initializer
  name: 'auth'
  after: 'store'
  initialize: (container, application) ->
    errHanler = (e) =>
      Ember.Logger.error e
      console.error 'The "me" user was not found for some reason!'
      throw e

    Radium.User.find(name: 'me').then(((records) =>
      user = records.get('firstObject')

      currentUserController = container.lookup('controller:currentUser')
      currentUserController.set 'model', user

      account = user.get('account')

      userSettingsController = container.lookup('controller:userSettings')
      userSettingsController.set('model', user.get('settings'))

      accountController = container.lookup('controller:account')
      accountController.set('model', user.get('account'))

      accountSettingsController = container.lookup('controller:accountSettings')
      accountSettingsController.set('model', user.get('account'))

      Radium.advanceReadiness()
    ), errHanler).then(null, errHanler)
