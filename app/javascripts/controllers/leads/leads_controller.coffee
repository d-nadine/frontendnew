Radium.LeadsController = Radium.ObjectController.extend
  needs: ['addressbook']

  addressbook: Ember.computed.oneWay "controllers.addressbook"
  untrackedTotal: Ember.computed.oneWay "addressbook.untrackedTotal"
