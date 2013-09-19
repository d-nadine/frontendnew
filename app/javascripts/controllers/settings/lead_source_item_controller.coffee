Radium.SettingsLeadSourceItemController = Radium.ObjectController.extend BufferedProxy,
  account: Ember.computed.alias 'parentController.account'
  edit: -> 
    @set 'isEditing', true

  cancel: ->
    @discardBufferedChanges()
    @set 'isEditing', false

  isValid: ( ->
    return false unless @get('isEditing')

    name = @get('name')

    !Ember.isEmpty(name) && name.length
  ).property('name', 'isEditing')

  save: ->
    unless @get('name.length')
      @send 'flashError', 'You must supply a value'
      @cancel()
      return

    return if @get('account.isSaving')

    @set('isEditing', false)

    @applyBufferedChanges()

    @send 'saveSources'
