Radium.TaskDeletionConfirmationController = Radium.ObjectController.extend
  actions:
    deleteTask: ->
      model = @get('model')

      model.deleteRecord()

      model.get('transaction').commit()

      @send 'closeModal'

Radium.TodoDeletionConfirmationController = Radium.TaskDeletionConfirmationController.extend()

Radium.CallDeletionConfirmationController = Radium.TaskDeletionConfirmationController.extend()
