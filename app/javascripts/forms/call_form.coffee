require 'forms/todo_form'

Radium.CallForm = Radium.TodoForm.extend
  canChangeContact: true

  data: (->
    hash = @_super()
    hash.kind = 'call'
    hash
  ).property().volatile()

  isValid: (->
    return unless @_super()
    return unless @get('reference')

    true
  ).property('reference', 'description', 'finishBy', 'user')
