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
    isBulk = Ember.isArray @get('reference')
    isNew = @get('isNew') && !isBulk

    if isBulk
      @get('reference').forEach (item) =>
        todo = Radium.Todo.createRecord @get('data')
        todo.set 'reference', item


        if item == @get('reference').slice().pop()
          todo.store.commit()

      return

    todo =
        if isNew
          Radium.Todo.createRecord @get('data')
        else
          @get('content')

    todo.store.commit()
