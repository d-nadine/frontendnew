Radium.PipelineViewBase = Ember.View.extend
  userPicker: Radium.UserPicker.extend
    disabledBinding: 'controller.isDisabled'
    valueBinding: 'controller.assignToUser'

  didInsertElement: ->
    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on

  onFormReset: ->
    @$('.action-forms form').each  ->
      @reset()

    @get('assignTodo').reset() if @get('assignTodo')
    @get('statusTodo').reset() if @get('statusTodo')

  statusPicker: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.changedStatus'

  assignTodoField: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.reassignTodo'
    placeholder: "Add related todo?"

  changeStatusTodo: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.statusTodo'
    placeholder: "Add related todo?"

  bulkLeader: ( ->
    form = @get('controller.activeForm')
    return unless form

    length = @get('controller.checkedContent.length')

    prefix =
      switch form
        when "assign" then "reassign "
        when "todo" then "add a todo about  "
        when "call" then "create and assign a call from  "
        when "status" then "change status on "
        when "email" then "email "
        else
          throw new Error("Unknown #{form} for bulkLeader")

    result =
      if length == 1
        "#{prefix} this lead"
      else
        "#{prefix} these selected #{@get('controller.checkedContent.length')} leads"

    return result unless form == "assign"

    result += " to"
  ).property('controller.activeForm', 'controller.checkedContent.length')
