Radium.SidebarContactStatusView = Radium.InlineEditorView.extend
  statusesBinding: 'controller.controllers.leadStatuses.statuses'
  statusDescriptionBinding: 'parentView.statusDescription'
  statusSelect: Ember.Select.extend
    contentBinding: 'parentView.statuses'
    optionValuePath: 'content.value'
    optionLabelPath: 'content.name'
    valueBinding: 'controller.form.status'
    change: (evt) ->
      @get('parentView').toggleEditor()
