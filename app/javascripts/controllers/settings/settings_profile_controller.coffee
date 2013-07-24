Radium.SettingsProfileController = Radium.ObjectController.extend BufferedProxy,
  isValid: ( ->
    !Ember.isEmpty(@get('firstName')) && !Ember.isEmpty(@get('lastName'))
  ).property('firstName', 'lastName')

  save: (user) ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @applyBufferedChanges()

    user = @get('model')

    user.one 'didUpdate', ->
      @send "flashSuccess", "Profile settings saved!"

    user.one 'becameInvalid', (result) =>
      @send 'flashError', result
      @resetModel()

    user.one 'becameError', (result) =>
      @send 'flashError', "an error happened and the profile could not be updated"
      @resetModel()

    user.get('transaction').commit()

    @discardBufferedChanges()

  cancel: (user) ->
    @set 'isSubmitted', false
    @discardBufferedChanges()
