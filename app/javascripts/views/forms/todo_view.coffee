require 'lib/radium/checkbox'
require 'views/forms/todo_field_view'
require 'lib/radium/user_picker'
require 'views/forms/form_view'
require 'views/forms/focus_textarea_mixin'

Radium.FormsTodoView = Radium.FormView.extend
  didInsertElement: ->
    @_super.apply this, arguments
    return unless @get('controller').on
    @get('controller').on('animateFinish', this, 'onAnimateFinish') if @get('controller').on

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

  onAnimateFinish: ->
    unless @$().length
      @get('controller').send 'completeFinish'
      return

    @$().fadeOut 'slow', =>
      @get('controller').send 'completeFinish'
