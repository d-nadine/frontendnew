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

  commit: ->
    isBulk = @get('isBulk')
    isNew = @get('isNew') && !isBulk

    todo =
        if isNew
          Radium.Todo.createRecord @get('data')
        else if isBulk
          @get('reference').forEach (item) =>
            todo = Radium.Todo.createRecord @get('data')
            todo.set 'reference', item
        else
          @get('content')

    todo.store.commit()
