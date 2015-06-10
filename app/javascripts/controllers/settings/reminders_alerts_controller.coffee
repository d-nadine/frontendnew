Radium.SettingsRemindersAlertsController = Radium.ObjectController.extend BufferedProxy,
  actions:
    update:  ->
      model = @get('model')

      model.save().then(=>
        @send 'flashSuccess', 'Your notificaiton settings have been updated.'
      ).catch (error) ->
        result.reset()

    cancel: ->
      @get('model.transaction').rollback()

  overdueTasksDisabled: Ember.computed.not 'notifications.overdueTasks.enabled'
  createdTasksOverdueTaskDisabled: Ember.computed.not 'notifications.createdOverdueTasks.enabled'
  locaMeetingsDisabled: Ember.computed.not 'notifications.localMeetings.enabled'
  remoteMeetingsDisabled: Ember.computed.not 'notifications.remoteMeetings.enabled'
  leadIgnoredDisabled: Ember.computed.not 'notifications.leadIgnored.enabled'
  clientIgnoredDisabled: Ember.computed.not 'notifications.clientIgnored.enabled'
  taskIngoredDisabled: Ember.computed.not 'notifications.taskIgnored.enabled'
