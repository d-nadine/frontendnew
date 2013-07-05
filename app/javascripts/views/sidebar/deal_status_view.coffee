Radium.SidebarDealStatusView = Radium.InlineEditorView.extend
  classNameBindings: [':deal-status']
  statusSelect: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.form.status'
    disabledBinding: 'controller.statusDisabled'
