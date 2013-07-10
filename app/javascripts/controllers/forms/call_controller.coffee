require 'controllers/forms/todo_controller'

Radium.FormsCallController = Radium.FormsTodoController.extend
  showCallBox: (->
    @get('reference') && @get('isEditable') && !@get('isFinished')
  ).property('reference', 'isEditable', 'isFinished')

  isContactPickerDisabled: (->
    return true if @get('canChangeContact') is false
    @get('isPrimaryInputDisabled')
  ).property('isPrimaryInputDisabled', 'canChangeContact')

  contacts: (->
    Radium.Contact.all().filter (contact) => contact.get('isPublic')
  ).property()
