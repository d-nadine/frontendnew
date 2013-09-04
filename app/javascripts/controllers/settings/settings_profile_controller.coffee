Radium.SettingsProfileController = Radium.ObjectController.extend BufferedProxy,
  needs: ['userSettings']
  settings: Ember.computed.alias 'controllers.userSettings'
  signatureBinding: 'controllers.userSettings.signature'

  isEditing: false
  toggleEdit: ->
    @toggleProperty('isEditing')

  isValid: ( ->
    !Ember.isEmpty(@get('firstName')) && !Ember.isEmpty(@get('lastName'))
  ).property('firstName', 'lastName')

  save: (user) ->
    @set 'isSubmitted', true

    return unless @get('isValid')

    @applyBufferedChanges()

    user = @get('model')

    user.one 'didUpdate', =>
      @send "flashSuccess", "Profile settings saved!"

    user.one 'becameInvalid', (result) =>
      @send 'flashError', result
      @resetModel()

    user.one 'becameError', (result) =>
      @send 'flashError', "an error happened and the profile could not be updated"
      @resetModel()

    user.get('settings').one 'didUpdate', =>
      @send 'flashSuccess', 'Signature updated'

    user.get('transaction').commit()

    @discardBufferedChanges()

  cancel: (user) ->
    @set 'isSubmitted', false
    @discardBufferedChanges()
