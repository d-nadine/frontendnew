require 'views/forms/todo_view'

Radium.FormsCallView = Radium.FormsTodoView.extend
  todoField: Radium.FormsTodoFieldView.extend
    placeholder: (->
      if @get('isCall') && @get('referenceName')
        "Add a call to #{@get('referenceName')} for #{@get('date').toHumanFormat()}"
      else
        "Add a call for #{@get('date').toHumanFormat()}"
    ).property('reference.name')

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
