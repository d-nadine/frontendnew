Radium.ReportsController = Ember.Controller.extend
  needs: ['account']
  account: Ember.computed.alias 'controllers.account'