Radium.SettingsRemindersAlertsController = Radium.ObjectController.extend BufferedProxy,
  overdueTaskDisabled: Ember.computed.not 'overdueTasks.enabled'
  update: (settings) ->
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
