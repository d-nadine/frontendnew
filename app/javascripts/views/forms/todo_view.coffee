require 'lib/radium/checkbox'
require 'views/forms/todo_field_view'
require 'lib/radium/user_picker'
require 'lib/radium/date_picker'
require 'views/forms/form_view'

Radium.FormsTodoView = Radium.FormView.extend
  checkbox: Radium.Checkbox.extend
    attributeBindings: 'title'
    checkedBinding: 'controller.isFinished'
    disabledBinding: 'controller.canFinish'
    title: (->
      if @get('controller.isFinished')
        "Mark as not done"
      else
        "Mark as done"
    ).property('controller.isDisabled', 'controller.isFinished')
    didInsertElement: ->
      unless @get('controller.isNew')
        @$().tooltip()

    willDestroyElement: ->
      if @$().data('tooltip')
        @$().tooltip('destroy')

  todoField: Radium.FormsTodoFieldView.extend
    value: 'controller.description'
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
    @get('description').reset()
