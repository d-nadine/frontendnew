require 'views/forms/todo_view'
require 'views/forms/combobox_view'

Radium.FormsCallView = Radium.FormsTodoView.extend
  todoField: Radium.FormsTodoFieldView.extend
    placeholder: 'about...'

  contactPicker: Radium.ComboboxView.extend
    sourceBinding: 'controller.contacts'
    valueBinding: 'controller.reference'
    placeholder: 'Choose a contact to call...'
    disabledBinding: 'controller.isPrimaryInputDisabled'

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
