Ember.onLoad 'Ember.Application', (Application) ->
  Ember.Application.initializer
    name: 'storeToComponent'
    before: 'registerComponentLookup'
    initialize: (container, application) ->
      application.inject('component', 'store', 'store:main')
