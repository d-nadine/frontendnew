Radium.ActivitiesCompanyController = Radium.ObjectController.extend
  isCreate: Ember.computed.is 'meta.event', 'create'
  isUpdate: Ember.computed.is 'meta.event', 'update'
  isAssign: Ember.computed.is 'meta.event', 'assign'

  company: Ember.computed.alias 'reference'
  assignedTo: Ember.computed.alias 'meta.user'
