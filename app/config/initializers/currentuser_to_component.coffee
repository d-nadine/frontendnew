Ember.Application.initializer
  name: 'currentUserToComponent'
  before: 'registerComponentLookup'
  initialize: (container, application) ->
    application.inject 'component', 'currentUser', 'controller:currentUser'
