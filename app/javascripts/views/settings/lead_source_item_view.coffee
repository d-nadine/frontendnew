Radium.SettingsLeadSourceItemView = Radium.View.extend
  leadSourceName: Ember.TextField.extend Ember.TargetActionSupport,
    valueBinding: 'targetObject.name'
    disabledBinding: 'targetObject.account.isSaving'
    action: 'save'
    target: 'controller'
    insertNewline: (e) ->
      @triggerAction()
      e.stopPropagation()
      e.preventDefault()
