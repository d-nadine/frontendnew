Radium.ActivitiesContactController = Radium.ObjectController.extend
  isPrimaryContact: Ember.computed.is 'meta.event', 'primary_contact'

  contact: Ember.computed.alias 'reference'
  company: Ember.computed.alias 'meta.company'
