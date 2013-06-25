Radium.NotificationSettings = DS.Model.extend
  overdueTaskDays: DS.attr('number')
  overdueTaskEnabled: DS.attr('boolean')

  assignedOverdueTaskDays: DS.attr('number')
  assignedOverdueTaskEnabled: DS.attr('boolean')

  localMeetingDays: DS.attr('number')
  localMeetingEnabled: DS.attr('boolean')

  outOfOfficeDays: DS.attr('number')
  outOfOfficeEnabled: DS.attr('boolean')

  leadIgnoredDays: DS.attr('number')
  leadIgnoredEnabled: DS.attr('boolean')

  clientIgnoredDays: DS.attr('number')
  clientIgnoredEnabled: DS.attr('boolean')

  taskIgnoredDays: DS.attr('number')
  taskIgnoredEnabled: DS.attr('boolean')