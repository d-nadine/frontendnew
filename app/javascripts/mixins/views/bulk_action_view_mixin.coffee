require 'lib/radium/user_picker'
require 'views/forms/todo_field_view'

Radium.BulkActionViewMixin = Ember.Mixin.create
  userPicker: Radium.UserPicker.extend
    disabledBinding: 'controller.isDisabled'
    valueBinding: 'controller.assignToUser'

  didInsertElement: ->
    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on

  onFormReset: ->
    if @$('.action-forms form')
      @$('.action-forms form').each  ->
        @reset()

    @get('assignTodo').reset() if @get('assignTodo')
    @get('statusTodo').reset() if @get('statusTodo')

  assignTodoField: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.reassignTodo'
    placeholder: "Add related todo?"
