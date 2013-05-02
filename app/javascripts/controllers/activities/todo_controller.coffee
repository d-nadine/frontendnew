Radium.ActivitiesTodoController = Radium.ObjectController.extend
  isFinish: Ember.computed.is 'event', 'finish'
  isAssign: Ember.computed.is 'event', 'assign'

  todo: Ember.computed.alias 'reference'
  assignedTo: Ember.computed.alias 'meta.user'

  icon: 'todo'
