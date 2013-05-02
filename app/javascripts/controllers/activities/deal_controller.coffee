Radium.ActivitiesDealController = Radium.ObjectController.extend
  isCreate: Ember.computed.is 'meta.event', 'create'
  isAssign: Ember.computed.is 'meta.event', 'assign'

  deal: Ember.computed.alias 'reference'
  contact: Ember.computed.alias 'reference.contact'
  reassignedTo: Ember.computed.alias 'meta.user'
