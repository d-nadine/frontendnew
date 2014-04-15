require 'lib/radium/checkbox'
require 'views/forms/todo_field_view'
require 'lib/radium/user_picker'
require 'views/forms/form_view'
require 'views/forms/focus_textarea_mixin'

Radium.FormsTodoView = Radium.FormView.extend
  checkbox: Radium.Checkbox.extend
    attributeBindings: 'title'
    checkedBinding: 'controller.isFinished'
    disabledBinding: 'controller.canFinish'
    title: (->
      if @get('controller.isFinished')
        "Mark as not done"
      else
        "Mark as done"
    ).property('controller.isDisabled', 'controller.isFinished')
    didInsertElement: ->
      unless @get('controller.isNew')
        @$().tooltip()

    willDestroyElement: ->
      if @$().data('tooltip')
        @$().tooltip('destroy')

  todoField: Radium.FormsTodoFieldView.extend Radium.TextFieldFocusMixin,
    Radium.FocusTextareaMixin,

    value: 'controller.description'
    disabledBinding: 'controller.isPrimaryInputDisabled'
    finishBy: Ember.computed.alias 'controller.finishBy'
    placeholder: (->
      pre = if @get('referenceName') and !@get('controller.reference.token')
              "Add a todo about #{@get('referenceName')}"
            else
              "Add a todo"

      return pre unless @get('finishBy')

      "#{pre} for #{@get('finishBy').toHumanFormat()}"
    ).property('reference.name', 'controller.finishBy')

  userPicker: Radium.UserPicker.extend
    disabledBinding: 'controller.isDisabled'

  onFormReset: ->
    if description = @get('description')
      description.reset()

  referenceIcon: (->
    className = null
      
    switch @get('controller.reference.typeName')
      when 'deal' then className = 'ss-briefcase'
      when 'contact' then className = 'ss-user'
      when 'email' then className = 'ss-mail'
      when 'company' then className = 'ss-buildings'
      when 'meeting' then className = 'ss-calendar'
      when 'todo' then className = 'ss-check'
      else className = "ss-view"

    className
  ).property('controller.reference')
