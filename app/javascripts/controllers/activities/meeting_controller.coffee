Radium.ActivitiesMeetingController = Radium.ObjectController.extend
  isReschedule: Ember.computed.is 'meta.event', 'reschedule'
  isCancel: Ember.computed.is 'meta.event', 'cancel'
  isCreate: Ember.computed.is 'meta.event', 'create'
  isUpdate: Ember.computed.is 'meta.event', 'update'

  meeting: Ember.computed.alias 'reference'
  participants: Ember.computed.alias 'reference.participants'
  newTime: Ember.computed.alias 'meta.time'
