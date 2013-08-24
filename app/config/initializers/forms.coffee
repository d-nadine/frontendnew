Ember.Application.initializer
  name: 'giveStoreToForms'
  initialize: (container, application) ->
    return if Radium.Form.store

    currentUser = container.lookup('controller:currentUser')

    Radium.Form.reopen
      store: container.lookup('store:main')
      currentUser: currentUser
