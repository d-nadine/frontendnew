require 'lib/radium/checkbox'
require 'views/forms/todo_field_view'
require 'lib/radium/user_picker'
require 'lib/radium/date_picker'
require 'views/forms/form_view'

Radium.FormsTodoView = Radium.FormView.extend
  checkbox: Radium.Checkbox.extend
    checkedBinding: 'controller.isFinished'
    disabledBinding: 'controller.canFinish'

  didInsertElement: ->
    @get('controller').on 'formReset', this, 'onFormReset'

  todoField: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.description'
    disabledBinding: 'controller.isPrimaryInputDisabled'
    placeholder: (->
      if @get('referenceName')
        "Add a todo about #{@get('referenceName')} for #{@get('date').toHumanFormat()}"
      else
        "Add a todo for #{@get('date').toHumanFormat()}"
    ).property('reference.name')

  datePicker: Radium.DatePicker.extend
    dateBinding: 'controller.finishBy'

  userPicker: Radium.UserPicker.extend
    disabledBinding: 'controller.isDisabled'

  onFormReset: ->
    @$('form')[0].reset()
    @get('todoDescription').reset()
    false
