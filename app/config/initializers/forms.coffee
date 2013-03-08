Ember.Application.initializer
  name: 'giveStoreToForms'
  initialize: (container, application) ->
    return if Radium.Form.store

    Radium.Form.reopen
      store: container.lookup('store:main')
