Radium.LeadsController = Radium.Controller.extend
  needs: ['addressbook']

  addressbook: Ember.computed.oneWay "controllers.addressbook"
  untrackedTotal: Ember.computed.oneWay "addressbook.untrackedTotal"
