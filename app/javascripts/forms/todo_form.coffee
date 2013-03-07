require 'forms/form'
Radium.TodoForm = Radium.Form.extend
  isEditable: true

  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
  ).property().volatile()

  isValid: ( ->
    return if Ember.isEmpty(@get('description'))
    return if @get('finishBy').isBeforeToday()
    return unless @get('user')

    true
  ).property('description', 'finishBy', 'user')


Radium.TodoForm.reopenClass
  generate: ->
     Ember.computed 'todoFormDefaults', ->
       Radium.TodoForm.create
        content: Ember.Object.create()
        isNew: true
        defaults: @get('todoFormDefaults')
