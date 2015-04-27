Ember.Application.initializer
  name: 'configureForms'
  after: 'load-services'
  initialize: (container, application) ->
    return if Radium.Form.store

    currentUser = container.lookup('controller:currentUser')

    eventBus = container.lookup('event-bus:current')

    Radium.Form.reopen
      EventBus: eventBus
      store: container.lookup('store:main')
      currentUser: currentUser
