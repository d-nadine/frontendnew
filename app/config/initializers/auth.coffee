Ember.Application.initializer
  name: 'auth'
  after: 'store'
  initialize: (container, application) ->
    errHanler = =>
      console.error 'The "me" user was not found for some reason!'

    Radium.User.find('me').then(((user) =>
      currentUserController = container.lookup('controller:currentUser')
      currentUserController.set 'model', user

      settingsController = container.lookup('controller:settings')
      settingsController.set('model', user.get('settings'))

      Radium.advanceReadiness()
    ), errHanler)
