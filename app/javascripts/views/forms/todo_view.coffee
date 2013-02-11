Radium.FormsTodoView = Ember.View.extend
  expandForm: ->
    @toggleProperty 'expanded'

  keyPress: (event) ->
    return unless event.keyCode == 13
    @submit()

  optionsLabel: (->
    if @get('expanded') then 'hide' else 'options'
  ).property('expanded')

  didInsertElement: ->
    @get('controller').reset()

    @$('.shortcut').popover
      html: true
      content: @$().find('.shortcuts').html()
    @focusDescription()

  focusDescription: ->
    @$('.todo').focus()

  descriptionField: Ember.TextField.extend
    valueBinding: 'controller.description'
    classNames: ['todo']
    classNameBindings: ['invalid']
    invalid: (->
      @get('controller.isDescriptionValid') == false
    ).property('controller.isDescriptionValid')

    placeHolder: "Todo..."


  checkbox: Ember.Checkbox.extend
    checkedBinding: 'controller.finished'

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
    @focusDescription()
