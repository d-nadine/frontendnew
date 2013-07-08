require 'forms/todo_form'

Radium.CallForm = Radium.TodoForm.extend
  canChangeContact: true

  type: ( ->
    Radium.Call
  ).property()

  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
    contact: @get('contact')
  ).property().volatile()

  isValid: (->
    return unless @_super()
    return unless @get('contact')

    true
  ).property('contact', 'description', 'finishBy', 'user')
