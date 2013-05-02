Radium.ActivitiesDealController = Radium.ObjectController.extend
  isDelete: Ember.computed.is 'event', 'delete'
  isAssign: Ember.computed.is 'event', 'assign'
  isStatusChange: Ember.computed.is 'event', 'status_change'
  isPublish: Ember.computed.is 'event', 'publish'

  deal: Ember.computed.alias 'reference'
  value: Ember.computed.alias 'deal.value'

  contact: Ember.computed.alias 'reference.contact'
  reassignedTo: Ember.computed.alias 'meta.user'
  status: Ember.computed.alias 'meta.status'
  isNegotiating: Ember.computed.alias 'meta.negotiating'
