Radium.Router = Ember.Router.extend
  enableLogging: true

  root: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'

