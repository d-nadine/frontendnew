require 'lib/radium/checkbox'
require 'views/forms/todo_field_view'
require 'lib/radium/user_picker'
require 'lib/radium/date_picker'

Radium.FormsTodoView = Ember.View.extend
  checkbox: Radium.Checkbox.extend
    checkedBinding: 'controller.isFinished'
    disabledBinding: 'controller.canFinish'

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

  submit: ->
    isNew = @get('controller.isNew')

    @get('controller').submit()

    return unless @get('controller.isValid')

    return false unless isNew

    @$('form')[0].reset()
    @get('todoDescription').reset()
    false
