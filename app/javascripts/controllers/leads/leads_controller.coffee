Radium.LeadsController = Radium.Controller.extend
  needs: ['addressbook']

  addressbook: Ember.computed.oneWay "controllers.addressbook"
