require 'lib/radium/combobox'
require 'lib/radium/group_autocomplete'

Radium.ContactSidebarView = Radium.SidebarView.extend
  classNames: ['sidebar-panel-bordered']

  statuses: ( ->
    @get('controller.leadStatuses').map (status) ->
      Ember.Object.create
        name: status.name
        value: status.value
  ).property('controller.leadStatuses.[]')

  statusSelect: Ember.Select.extend
    contentBinding: 'parentView.statuses'
    optionValuePath: 'content.value'
    optionLabelPath: 'content.name'
    valueBinding: 'controller.status'

  contactInlineEditor: Radium.InlineEditorView.extend
    click:  (evt) ->
      @_super.apply this, arguments

      return unless @get 'isEditing'
      Ember.run.scheduleOnce 'afterRender', this, 'highlightSelection'

    highlightSelection: ->
      @$('input').select()

  groups: Radium.GroupAutoComplete.extend
    isEditableBinding: 'controller.isEditable'
