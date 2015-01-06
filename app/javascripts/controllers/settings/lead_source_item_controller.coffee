Radium.SettingsLeadSourceItemController = Radium.ObjectController.extend BufferedProxy,
  actions:
    edit: ->
      @set 'isEditing', true

    cancel: ->
      @discardBufferedChanges()
      @set 'isEditing', false

    isValid: Ember.computed 'name', 'isEditing', ->
      return false unless @get('isEditing')

      name = @get('name')

      !Ember.isEmpty(name) && name.length

    save: ->
      unless @get('name.length')
        @send 'flashError', 'You must supply a value'
        @send 'cancel'
        return

      return if @get('account.isSaving')

      @set('isEditing', false)

      @applyBufferedChanges()

      @send 'saveSources'

  account: Ember.computed.oneWay 'parentController.account'
