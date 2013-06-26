Radium.SettingsRemindersAlertsController = Ember.ObjectController.extend
  overdueTaskDisabled: Ember.computed.not 'reminders.overdueTaskEnabled'
  assignedOverdueTaskDisabled: Ember.computed.not 'reminders.assignedOverdueTaskEnabled'
  localMeetingDisabled: Ember.computed.not 'reminders.localMeetingEnabled'
  outOfOfficeDisabled: Ember.computed.not 'reminders.outOfOfficeEnabled'
  leadIgnoredDisabled: Ember.computed.not 'reminders.leadIgnoredEnabled'
  clientIgnoredDisabled: Ember.computed.not 'reminders.clientIgnoredEnabled'
  taskIgnoredDisabled: Ember.computed.not 'reminders.taskIgnoredEnabled'

  save: ->
    @get('store').commit()

  cancel: ->
    @get('content.transaction').rollback()