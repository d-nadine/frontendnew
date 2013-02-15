require 'controllers/forms/todo_controller'

Radium.FormsCallController = Radium.FormsTodoController.extend
  showCallBox: (->
    @get('reference') && @get('isEditable') && !@get('isFinished')
  ).property('reference', 'isEditable', 'isFinished')
