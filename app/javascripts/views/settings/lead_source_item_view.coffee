Radium.SettingsLeadSourceItemView = Radium.View.extend
  leadSourceName: Ember.TextField.extend Ember.TargetActionSupport,
    valueBinding: 'controller.name'
    disabledBinding: 'controller.account.isSaving'
    action: 'save'
    target: 'controller'
    insertNewline: (e) ->
      @triggerAction()
      e.stopPropagation()
      e.preventDefault()
