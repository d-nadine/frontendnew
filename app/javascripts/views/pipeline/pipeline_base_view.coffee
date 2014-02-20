require 'mixins/views/bulk_action_view_mixin'

Radium.PipelineViewBase = Ember.View.extend Radium.BulkActionViewMixin,
  statusPicker: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.changedStatus'

  lostBecause: Radium.TextArea.extend(Ember.TargetActionSupport,
    classNameBindings: ['isValid', 'isInvalid']
    placeholder: 'Supply a reason why this deal was lost.'
    valueBinding: 'targetObject.lostBecause'
    classNames: ['new-comment']
    isValid: (->
      return unless @get('targetObject.isLost')
      @get('value.length')
    ).property('value', 'targetObject.isSubmitted', 'targetObject.isLost')
    isInvalid: ( ->
      return unless @get('targetObject.isSubmitted')
      not @get('isValid')
    ).property('value', 'targetObject.isSubmitted', 'targetObject.isLost')
  )

  changeStatusTodo: Radium.FormsTodoFieldView.extend
    valueBinding: 'targetObject.statusTodo'
    placeholder: "Add related todo?"

  bulkLeader: ( ->
    form = @get('controller.activeForm')
    return unless form

    length = @get('controller.checkedContent.length')

    prefix =
      switch form
        when "assign" then "Reassign "
        when "todo" then "Add a Todo About  "
        when "call" then "Create and Assign a Call from  "
        when "status" then "Change status on "
        when "email" then "Email "
        else
          throw new Error("Unknown #{form} for bulkLeader")

    resource = if @get('controller.checkedContent.firstObject').constructor == Radium.Deal then 'deal' else 'lead'

    result =
      if length == 1
        "#{prefix} this #{resource}"
      else
        "#{prefix} these selected #{@get('controller.checkedContent.length')} #{resource}s"

    return result unless form == "assign"

    result += " to"
  ).property('controller.activeForm', 'controller.checkedContent.[]')
