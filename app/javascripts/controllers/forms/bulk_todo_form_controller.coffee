require 'controllers/forms/todo_form_controller'

Radium.FormsBulkTodoFormController = Radium.FormsTodoFormController.extend
  selection: null

  submit: ->
    selection = @get('selection')

    return unless selection?.get('length')

    selection.forEach (reference) =>
      todo = Radium.Todo.createRecord
        kind: @get('kind')
        finishBy: @get('finishBy')
        user: @get('currentUser')
        description: @get('description')

      todo.set('reference', reference)

    @get('content').store.commit()

    Radium.Utils.notify('Todos created!')
