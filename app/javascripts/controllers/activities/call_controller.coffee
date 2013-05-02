Radium.ActivitiesCallController = Radium.ObjectController.extend
  isCreate: Ember.computed.is 'event', 'create'

  call: Ember.computed.alias 'reference'
  description: Ember.computed.alias 'reference.description'
  # FIXME: change this when call model is updated
  contact: Ember.computed.alias 'reference.reference'

  icon: 'call'
