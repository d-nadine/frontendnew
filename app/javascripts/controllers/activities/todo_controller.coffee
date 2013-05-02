Radium.ActivitiesTodoController = Radium.ObjectController.extend
  isFinish: Ember.computed.is 'meta.event', 'finish'
  isAssign: Ember.computed.is 'meta.event', 'assign'

  todo: Ember.computed.alias 'reference'
  assignedTo: Ember.computed.alias 'meta.user'
