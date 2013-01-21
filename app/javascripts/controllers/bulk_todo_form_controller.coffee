Radium.BulkTodoFormController = Radium.TodoFormController.extend
  selection: null

  submit: ->
    selection = @get('selection')

    return unless selection?.get('length')

    selection.forEach (reference) =>
      todo = Radium.Todo.createRecord
        kind: @get('kind')
        finishBy: @get('finishBy')
        user: Radium.get('router.currentUser')
        description: @get('description')

      todo.set('reference', reference)

    @get('content').store.commit()

    Radium.Utils.notify('Todos created!')
