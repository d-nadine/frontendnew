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

  finishView: Radium.View.extend Ember.ViewTargetActionSupport,
    tagName: 'button'
    classNameBindings: ["isFinished", ":btn", ":btn-link", ":pull-left", ":events-list-item-button"]
    attributeBindings: 'title'

    didInsertElement: ->
      @_super.apply this, arguments
      unless @get('controller.isNew')
        @$().tooltip()

    willDestroyElement: ->
      @_super.apply this, arguments

      if @$().data('tooltip')
        @$().tooltip('destroy')

    click: ->
      @triggerAction
        action: 'finishTask'

      false

    template: Ember.Handlebars.compile """
      <i class="ss-standard ss-check"></i>
    """

    title: Ember.computed 'controller.isDisabled', 'controller.isFinished', ->
      if @get('controller.isFinished')
        "Mark as not done"
      else
        "Mark as done"

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
    controller = @get('controller')

    unless @$()?.length
      controller.send 'completeFinish'
      return

    @$().fadeOut 'slow', =>
      controller.send 'completeFinish'
