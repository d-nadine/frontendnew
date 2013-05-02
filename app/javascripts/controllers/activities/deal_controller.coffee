Radium.ActivitiesDealController = Radium.ObjectController.extend
  isCreate: Ember.computed.is 'meta.event', 'create'
  isDelete: Ember.computed.is 'meta.event', 'delete'
  isAssign: Ember.computed.is 'meta.event', 'assign'

  deal: Ember.computed.alias 'reference'
  contact: Ember.computed.alias 'reference.contact'
  reassignedTo: Ember.computed.alias 'meta.user'
