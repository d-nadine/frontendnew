Radium.ActivitiesDealController = Radium.ObjectController.extend
  isCreate: Ember.computed.is 'meta.event', 'create'
  isDelete: Ember.computed.is 'meta.event', 'delete'
  isAssign: Ember.computed.is 'meta.event', 'assign'
  isStatusChange: Ember.computed.is 'meta.event', 'status_change'

  deal: Ember.computed.alias 'reference'
  contact: Ember.computed.alias 'reference.contact'
  reassignedTo: Ember.computed.alias 'meta.user'
  status: Ember.computed.alias 'meta.status'
  isNegotiating: Ember.computed.alias 'meta.negotiating'
