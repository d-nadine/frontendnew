Ember.Application.initializer
  name: 'adapterUrl'
  after: 'store'
  initialize: (container, application) ->
    store = container.lookup('store:main')

    store.get('_adapter').reopen
      url: 'http://localhost:9292'
