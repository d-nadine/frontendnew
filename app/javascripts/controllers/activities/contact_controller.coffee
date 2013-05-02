Radium.ActivitiesContactController = Radium.ObjectController.extend
  isPrimaryContact: Ember.computed.is 'meta.event', 'primary_contact'
  isUpdate: Ember.computed.is 'meta.event', 'update'

  contact: Ember.computed.alias 'reference'
  company: Ember.computed.alias 'meta.company'
