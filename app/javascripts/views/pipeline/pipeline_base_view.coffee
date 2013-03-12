Radium.PipelineViewBase = Ember.View.extend
  userPicker: Radium.UserPicker.extend
    disabledBinding: 'controller.isDisabled'
    valueBinding: 'controller.assignToUser'

  checkAll: Ember.Checkbox.extend
    click: (event) ->
      event.stopPropagation()

    change: (event) ->
      @get('controller').toggleChecked()

  didInsertElement: ->
    @get('controller').on 'formReset', this, 'onFormReset'

  onFormReset: ->
    @$('.action-forms form').each  ->
      @reset()

    @get('assignTodo').reset()

  statusPicker: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.changedStatus'

  assignTodoField: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.reassignTodo'
    placeholder: "Add related todo?"

  changeStatusTodo: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.changeStatusTodo'
    placeholder: "Add related todo?"

  bulkLeader: ( ->
    form = @get('controller.activeForm')
    return unless form

    length = @get('controller.checkedContent.length')

    prefix =
      switch form
        when "assign" then "REASSIGN "
        when "todo" then "ADD A TODO ABOUT  "
        when "call" then "CREATE AND ASSIGN A CALL FROM  "
        when "status" then "CHANGE STATUS ON "
        else
          throw new Error("Unknown #{form} for bulkLeader")

    result =
      if length == 1
        "#{prefix} THIS LEAD"
      else
        "#{prefix} THESE SELECTED #{@get('controller.checkedContent.length')} LEADS"

    return result unless form == "assign"

    result += " TO"
  ).property('controller.activeForm', 'controller.checkedContent.length')
