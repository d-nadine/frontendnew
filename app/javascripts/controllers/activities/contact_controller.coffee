Radium.ActivitiesContactController = Radium.ObjectController.extend
  isPrimaryContact: Ember.computed.is 'meta.event', 'primary_contact'
  isCreate: Ember.computed.is 'meta.event', 'create'
  isUpdate: Ember.computed.is 'meta.event', 'update'
  isStatusChange: Ember.computed.is 'meta.event', 'status_change'
  isAssign: Ember.computed.is 'meta.event', 'assign'
  isDelete: Ember.computed.is 'meta.event', 'delete'

  contact: Ember.computed.alias 'reference'
  company: Ember.computed.alias 'meta.company'
  status: Ember.computed.alias 'meta.status'
  assignedTo: Ember.computed.alias 'meta.user'
  hasStatus: (->
    @get('status') isnt 'none'
  ).property('status')
