Radium.SettingsRemindersAlertsController = Radium.ObjectController.extend BufferedProxy,
  overdueTasksDisabled: Ember.computed.not 'notifications.overdueTasks.enabled'
  createdTasksOverdueTaskDisabled: Ember.computed.not 'notifications.createdOverdueTasks.enabled'
  locaMeetingsDisabled: Ember.computed.not 'notifications.localMeetings.enabled'
  remoteMeetingsDisabled: Ember.computed.not 'notifications.remoteMeetings.enabled'
  leadIgnoredDisabled: Ember.computed.not 'notifications.leadIgnored.enabled'
  clientIgnoredDisabled: Ember.computed.not 'notifications.clientIgnored.enabled'
  taskIngoredDisabled: Ember.computed.not 'notifications.taskIgnored.enabled'

  update:  ->
    @applyBufferedChanges()

    model = @get('model')

    model.one 'didUpdate', =>
      @send 'flashSuccess', 'Your notificaiton settings have been updated.'

    model.one 'becameError', (result) =>
      @send 'flashError', result

    model.one 'becameInvalid', (result) =>
      @send 'flashError', result

    @get('store').commit()

    @discardBufferedChanges()

  cancel: ->
    @discardBufferedChanges()
