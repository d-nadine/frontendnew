require 'views/forms/checkbox_view'
require 'views/forms/todo_field_view'
require 'views/forms/user_picker_view'
require 'views/forms/date_picker_view'

Radium.FormsTodoView = Ember.View.extend
  checkbox: Radium.FormsCheckboxView.extend
    checkedBinding: 'controller.isFinished'

  todoField: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.description'
    placeholder: (->
      if @get('referenceName')
        "Add a todo about #{@get('referenceName')} for #{@get('date').toHumanFormat()}"
      else
        "Add a todo for #{@get('date').toHumanFormat()}"
    ).property('reference.name')

  datePicker: Radium.FormsDatePickerView.extend
    dateBinding: 'controller.finishBy'

  userPicker: Radium.FormsUserPickerView.extend()

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
