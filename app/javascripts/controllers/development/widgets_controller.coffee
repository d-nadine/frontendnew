Radium.DevelopmentWidgetsController = Ember.Controller.extend
  needs: ['users']

  date: Ember.DateTime.create()

  user: null
