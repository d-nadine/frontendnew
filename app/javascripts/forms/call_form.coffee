require 'forms/todo_form'

Radium.CallForm = Radium.TodoForm.extend
  kind: 'call'
  canChangeContact: true

  isValid: (->
    return unless @_super()
    return unless @get('reference')

    true
  ).property('reference', 'description', 'finishBy', 'user')
