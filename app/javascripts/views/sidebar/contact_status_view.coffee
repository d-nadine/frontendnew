Radium.SidebarContactStatusView = Radium.InlineEditorView.extend
  statuses: Ember.computed.oneWay 'controller.contactStatuses'

  statusSelect: Ember.Select.extend
    contentBinding: 'parentView.statuses'
    optionValuePath: 'content.id'
    optionLabelPath: 'content.name'
    valueBinding: 'controller.form.contactStatus.id'
